-- ai_swarm.lua — WezTerm マルチエージェント制御エンジン
local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

-- カスタマイズ可能な設定
M.config = {
    launch_key = 's',
    broadcast_key = 'b',
}

-- 内部状態
local _state = {
    worker_pane_ids = {},
    manager_pane_id = nil,
    swarm_active = false,
    pane_status = {},
}

---------------------------------------
-- ユーティリティ関数
---------------------------------------

--- ペインの作業ディレクトリを取得（URI/テーブル両対応）
---@param pane userdata
---@return string|nil
local function _get_cwd(pane)
    local cwd_uri = pane:get_current_working_dir()
    if not cwd_uri then
        return nil
    end
    -- WezTerm の戻り値はバージョンによって文字列またはテーブル
    if type(cwd_uri) == 'string' then
        -- file:///path/to/dir 形式
        return cwd_uri:gsub('^file://', ''):gsub('^/([A-Za-z]:)', '%1')
    elseif cwd_uri.file_path then
        return cwd_uri.file_path
    end
    return tostring(cwd_uri)
end

--- .ai_config.json を読み込む
---@param cwd string
---@return table|nil config
---@return string|nil error_message
local function _load_config(cwd)
    local path = cwd .. '/.ai_config.json'
    local f = io.open(path, 'r')
    if not f then
        return nil, 'not_found'
    end
    local content = f:read('*a')
    f:close()

    local ok, parsed = pcall(wezterm.json_parse, content)
    if not ok then
        return nil, 'JSON パースに失敗しました: ' .. tostring(parsed)
    end

    -- 必須フィールド検証
    if not parsed.manager then
        return nil, '必須フィールド "manager" がありません'
    end
    if not parsed.workers or #parsed.workers == 0 then
        return nil, '必須フィールド "workers" がありません（1つ以上必要）'
    end
    if not parsed.manager.command then
        return nil, 'manager.command は必須です'
    end
    for i, w in ipairs(parsed.workers) do
        if not w.command then
            return nil, 'workers[' .. i .. '].command は必須です'
        end
    end

    return parsed, nil
end

--- エージェント設定からコマンド文字列を構築
---@param agent table
---@param cwd string
---@return string
local function _build_command(agent, cwd)
    local cmd = agent.command
    if agent.prompt_file then
        local prompt_path = cwd .. '/' .. agent.prompt_file
        cmd = cmd .. ' --prompt-file ' .. wezterm.shell_quote_arg(prompt_path)
    end
    return cmd
end

--- AI_SWARM_README.md を生成
---@param cwd string
local function _generate_readme(cwd)
    local readme_path = cwd .. '/AI_SWARM_README.md'
    local f = io.open(readme_path, 'w')
    if not f then
        return
    end
    f:write([[# AI Swarm セットアップガイド

## 概要

WezTerm の AI Swarm 機能を使うと、マネージャー1名 × 複数ワーカーの
マルチエージェント環境を自動構築できます。

## セットアップ

プロジェクトルートに `.ai_config.json` を作成してください。

### `.ai_config.json` サンプル

```json
{
  "manager": {
    "role": "manager",
    "command": "claude",
    "dir": "./",
    "prompt_file": "agents/manager.md"
  },
  "workers": [
    {
      "role": "frontend",
      "command": "claude",
      "dir": "./src/frontend",
      "prompt_file": "agents/frontend.md"
    },
    {
      "role": "backend",
      "command": "claude",
      "dir": "./src/backend",
      "prompt_file": "agents/backend.md"
    }
  ]
}
```

### フィールド説明

| フィールド | 必須 | 説明 |
|---|---|---|
| `command` | はい | 実行するコマンド（例: `claude`） |
| `role` | いいえ | エージェントの役割名 |
| `dir` | いいえ | 作業ディレクトリ（プロジェクトルートからの相対パス） |
| `prompt_file` | いいえ | プロンプトファイルのパス（`--prompt-file` 引数として渡される） |

## 使い方

1. `Leader + s` で AI Swarm を起動
2. `Leader + b` で全ワーカーにメッセージをブロードキャスト

## ステータス通知

エージェントから WezTerm にステータスを通知するには、以下のエスケープシーケンスを発行します:

```bash
# 完了を通知
printf '\033]1337;SetUserVar=AI_STATUS=%s\007' "$(echo -n completed | base64)"

# エラーを通知
printf '\033]1337;SetUserVar=AI_STATUS=%s\007' "$(echo -n error | base64)"

# 実行中を通知
printf '\033]1337;SetUserVar=AI_STATUS=%s\007' "$(echo -n running | base64)"
```

ステータスバーに進捗が表示されます。
]])
    f:close()
end

---------------------------------------
-- レイアウト構築
---------------------------------------

--- Swarm レイアウトを構築してエージェントを起動
---@param window userdata
---@param pane userdata
---@param ai_config table
local function _launch_swarm(window, pane, ai_config)
    local cwd = _get_cwd(pane)
    if not cwd then
        window:toast_notification('AI Swarm', '作業ディレクトリを取得できません', nil, 3000)
        return
    end

    local n_workers = #ai_config.workers

    -- 上下分割: 上=マネージャ、下=ワーカー領域
    local worker_root = pane:split({
        direction = 'Bottom',
        size = 0.5,
    })
    _state.manager_pane_id = pane:pane_id()
    _state.pane_status[pane:pane_id()] = 'running'

    wezterm.sleep_ms(200)

    -- マネージャーの cd + コマンド起動
    local manager_dir = cwd
    if ai_config.manager.dir and ai_config.manager.dir ~= './' and ai_config.manager.dir ~= '.' then
        manager_dir = cwd .. '/' .. ai_config.manager.dir
    end
    local manager_cmd = _build_command(ai_config.manager, cwd)
    pane:send_text('cd ' .. wezterm.shell_quote_arg(manager_dir) .. ' && ' .. manager_cmd .. '\n')

    -- ワーカー領域を左から右へ分割
    local current_pane = worker_root
    _state.worker_pane_ids = {}

    for i = 1, n_workers do
        local target
        if i == n_workers then
            -- 最後のワーカーは残りのスペースを使用
            target = current_pane
        else
            -- 右側に残りワーカー分のスペースを確保して分割
            local new_pane = current_pane:split({
                direction = 'Right',
                size = (n_workers - i) / (n_workers - i + 1),
            })
            target = current_pane
            current_pane = new_pane
            wezterm.sleep_ms(200)
        end

        local worker = ai_config.workers[i]
        local worker_dir = cwd
        if worker.dir and worker.dir ~= './' and worker.dir ~= '.' then
            worker_dir = cwd .. '/' .. worker.dir
        end
        local worker_cmd = _build_command(worker, cwd)

        table.insert(_state.worker_pane_ids, target:pane_id())
        _state.pane_status[target:pane_id()] = 'running'

        target:send_text('cd ' .. wezterm.shell_quote_arg(worker_dir) .. ' && ' .. worker_cmd .. '\n')
    end

    _state.swarm_active = true
    window:toast_notification('AI Swarm', 'Swarm を起動しました（ワーカー: ' .. n_workers .. '）', nil, 3000)
end

---------------------------------------
-- ブロードキャスト
---------------------------------------

--- 全ワーカーにメッセージを送信
---@param window userdata
---@param message string
local function _broadcast(window, message)
    if not _state.swarm_active or #_state.worker_pane_ids == 0 then
        window:toast_notification('AI Swarm', 'Swarm が起動していません', nil, 3000)
        return
    end

    local mux = wezterm.mux
    local sent = 0
    for _, pane_id in ipairs(_state.worker_pane_ids) do
        local p = mux.get_pane(pane_id)
        if p then
            p:send_text('[Global Order]: ' .. message .. '\n')
            sent = sent + 1
        end
    end

    window:toast_notification('AI Swarm', sent .. ' ワーカーにメッセージを送信しました', nil, 3000)
end

---------------------------------------
-- ステータスバー更新
---------------------------------------

--- 右ステータスバーに Swarm 進捗を表示
---@param window userdata
local function _update_status_bar(window)
    if not _state.swarm_active then
        return
    end

    local total = #_state.worker_pane_ids
    local completed = 0
    local errors = 0
    for _, pane_id in ipairs(_state.worker_pane_ids) do
        local status = _state.pane_status[pane_id]
        if status == 'completed' then
            completed = completed + 1
        elseif status == 'error' then
            errors = errors + 1
        end
    end

    local elements = {}

    if errors > 0 then
        -- 赤: エラーあり
        table.insert(elements, { Foreground = { Color = '#ff6666' } })
        table.insert(elements, { Text = ' AI Swarm: ' .. completed .. '/' .. total .. ' 完了 | ' .. errors .. ' エラー ' })
    elseif completed == total then
        -- 緑: 全完了
        table.insert(elements, { Foreground = { Color = '#66ff66' } })
        table.insert(elements, { Text = ' AI Swarm: ' .. completed .. '/' .. total .. ' 完了 ' })
    else
        -- オレンジ: 実行中
        table.insert(elements, { Foreground = { Color = '#d4843e' } })
        table.insert(elements, { Text = ' AI Swarm: ' .. completed .. '/' .. total .. ' 完了 ' })
    end

    window:set_right_status(wezterm.format(elements))
end

---------------------------------------
-- イベント登録
---------------------------------------

--- user-var-changed イベントを登録
local function _register_events()
    wezterm.on('user-var-changed', function(window, pane, name, value)
        if name ~= 'AI_STATUS' then
            return
        end

        local pane_id = pane:pane_id()
        if _state.pane_status[pane_id] then
            _state.pane_status[pane_id] = value
            _update_status_bar(window)
        end
    end)

    wezterm.on('update-status', function(window, _pane)
        _update_status_bar(window)
    end)
end

---------------------------------------
-- 公開 API
---------------------------------------

--- キーバインド配列を返す
---@return table
function M.get_keys()
    return {
        -- Leader + s: Swarm 起動
        {
            key = M.config.launch_key,
            mods = 'LEADER',
            action = wezterm.action_callback(function(window, pane)
                local cwd = _get_cwd(pane)
                if not cwd then
                    window:toast_notification('AI Swarm', '作業ディレクトリを取得できません', nil, 3000)
                    return
                end

                local ai_config, err = _load_config(cwd)
                if not ai_config then
                    if err == 'not_found' then
                        _generate_readme(cwd)
                        window:toast_notification(
                            'AI Swarm',
                            '.ai_config.json が見つかりません。\nAI_SWARM_README.md を生成しました。',
                            nil,
                            5000
                        )
                    else
                        window:toast_notification('AI Swarm', 'エラー: ' .. err, nil, 5000)
                    end
                    return
                end

                _launch_swarm(window, pane, ai_config)
            end),
        },
        -- Leader + b: ブロードキャスト
        {
            key = M.config.broadcast_key,
            mods = 'LEADER',
            action = act.PromptInputLine({
                description = 'AI Swarm: 全ワーカーへのメッセージを入力',
                action = wezterm.action_callback(function(window, _pane, line)
                    if line and line ~= '' then
                        _broadcast(window, line)
                    end
                end),
            }),
        },
    }
end

--- セットアップ（wezterm.lua から呼ぶ）
---@param config table WezTerm config オブジェクト
function M.setup(config)
    _register_events()
end

return M
