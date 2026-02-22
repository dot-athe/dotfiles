# AI Swarm — WezTerm マルチエージェント制御ガイド

## 概要

AI Swarm は WezTerm 上でマネージャー1名 × 複数ワーカーのマルチエージェント環境を自動構築する Lua モジュールです。プロジェクトごとに `.ai_config.json` を配置するだけで、チーム構成を動的に読み込んでペインレイアウトを構築します。

## 構成ファイル

| ファイル | 役割 |
|---|---|
| `.config/wezterm/ai_swarm.lua` | モジュール本体 |
| `.config/wezterm/keybinds.lua` | キーバインド統合（`ai_swarm.get_keys()` をマージ） |
| `.config/wezterm/wezterm.lua` | `require('ai_swarm').setup(config)` でイベント登録 |

## 使い方

### 1. プロジェクトに `.ai_config.json` を作成

プロジェクトルートに以下のような設定ファイルを配置します。

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

### 2. Swarm を起動

WezTerm でプロジェクトディレクトリを開き、`Ctrl+G` → `s` を押すと自動的にペインが分割され、各エージェントが起動します。

```
┌──────────────────────────────┐
│      Manager (上半分)         │
├─────────┬──────────┬─────────┤
│ Worker1 │ Worker2  │ Worker3 │
└─────────┴──────────┴─────────┘
```

### 3. ブロードキャスト

`Ctrl+G` → `b` で入力ダイアログが表示されます。入力したメッセージが `[Global Order]: <メッセージ>` の形式で全ワーカーペインに送信されます。

## キーバインド一覧

| キー | 動作 |
|---|---|
| `Leader + s` | Swarm 起動（`.ai_config.json` を読み込みレイアウト構築） |
| `Leader + b` | 全ワーカーへメッセージをブロードキャスト |

※ Leader キーは `Ctrl+G`（タイムアウト: 2秒）

## `.ai_config.json` フィールド仕様

### `manager`（必須）

| フィールド | 必須 | 説明 |
|---|---|---|
| `command` | はい | 実行するコマンド（例: `claude`） |
| `role` | いいえ | エージェントの役割名 |
| `dir` | いいえ | 作業ディレクトリ（プロジェクトルートからの相対パス） |
| `prompt_file` | いいえ | プロンプトファイルのパス（`--prompt-file` 引数として渡される） |

### `workers`（必須・1つ以上）

各ワーカーのフィールドは `manager` と同じです。

## ステータスバー連携

エージェントが以下のエスケープシーケンスを出力すると、WezTerm の右ステータスバーに進捗が表示されます。

```bash
# 実行中
printf '\033]1337;SetUserVar=AI_STATUS=%s\007' "$(echo -n running | base64)"

# 完了
printf '\033]1337;SetUserVar=AI_STATUS=%s\007' "$(echo -n completed | base64)"

# エラー
printf '\033]1337;SetUserVar=AI_STATUS=%s\007' "$(echo -n error | base64)"
```

### 表示例

| 状態 | 表示（色） |
|---|---|
| 実行中 | `AI Swarm: 1/3 完了`（オレンジ） |
| 全完了 | `AI Swarm: 3/3 完了`（緑） |
| エラーあり | `AI Swarm: 2/3 完了 | 1 エラー`（赤） |

## エラーハンドリング

| 状況 | 動作 |
|---|---|
| `.ai_config.json` が存在しない | `AI_SWARM_README.md` を自動生成し、toast で通知 |
| JSON パースに失敗 | toast でエラー内容を表示 |
| 必須フィールドが不足 | toast で不足フィールドを表示 |
| ブロードキャスト時に Swarm 未起動 | toast で通知 |
| ワーカーペインが閉じ済み | スキップして残りのペインに送信 |

## カスタマイズ

`ai_swarm.lua` 内の `M.config` を変更することでキーバインドを変更できます。

```lua
M.config = {
    launch_key = 's',    -- 起動キー（デフォルト: s）
    broadcast_key = 'b', -- ブロードキャストキー（デフォルト: b）
}
```
