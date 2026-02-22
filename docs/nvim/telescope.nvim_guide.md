# telescope.nvim セットアップガイド

## ドキュメント
- [GitHub Repository](https://github.com/nvim-telescope/telescope.nvim)

## 概要
**telescope.nvim** は、NeoVim 用の拡張可能な「あいまい検索 (Fuzzy Finder)」プラグインです。
ファイル名、バッファ、ライブGREP（全文検索）、Gitステータスなど、あらゆるリストを高速にフィルタリング・プレビュー・選択できます。
VSCodeの「コマンドパレット」や「Cmd+P」に相当する機能を、より強力に提供します。

## 前提条件
- **NeoVim Version**: `v0.9.0` 以上 (推奨)
- **Lazy.nvim**: プラグインマネージャー
- **ripgrep**: `live_grep` コマンドを使用するために必須
  ```bash
  brew install ripgrep
  ```
- **fd**: `find_files` の高速化のために推奨
  ```bash
  brew install fd
  ```

## 設定例 (lazy.nvim)
`lua/plugins/telescope.lua` を作成し、以下のコードを記述します。
ここには、よく使うキーバインド (`<leader>ff`, `<leader>fg` 等) の設定も含まれています。

```lua
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- 検索パフォーマンスを向上させるための拡張機能 (makeビルドが必要)
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- Ctrl+k で上移動
            ["<C-j>"] = actions.move_selection_next,     -- Ctrl+j で下移動
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    -- FZF拡張のロード
    telescope.load_extension("fzf")
  end,
  -- キーバインド設定
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root)" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep (Root)" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
    { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Find Commands" },
    -- Git関連
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
  },
}
```

## 基本操作一覧

よく使うコマンド（Pickers）と、デフォルト設定での操作方法です。

### 主要コマンド (Pickers)
| コマンド | 説明 | 一般的なキーマップ |
| :--- | :--- | :--- |
| `find_files` | ファイル名をあいまい検索 | `<leader>ff` |
| `live_grep` | プロジェクト全体を全文検索 (ripgrep) | `<leader>fg` |
| `buffers` | 開いているバッファ（タブ）を検索 | `<leader>fb` |
| `help_tags` | ヘルプドキュメントを検索 | `<leader>fh` |
| `oldfiles` | 最近開いたファイルを検索 | `<leader>fr` |
| `resume` | 前回の検索結果を再表示 | `<leader>sx` |

### 検索ウィンドウ内での操作
| キー (Insert Mode) | アクション |
| :--- | :--- |
| `Ctrl + n` / `Ctrl + j` | 次の項目へ移動 (下) |
| `Ctrl + p` / `Ctrl + k` | 前の項目へ移動 (上) |
| `Ctrl + c` / `Esc` | 閉じる |
| `<CR>` (Enter) | ファイルを開く |
| `Ctrl + x` | 水平分割で開く |
| `Ctrl + v` | 垂直分割で開く |
| `Ctrl + t` | 新しいタブで開く |
| `Ctrl + /` | キーマップのヘルプを表示 |

## トラブルシューティング
- **`live_grep` が動かない**: `ripgrep` がインストールされているか確認してください (`brew install ripgrep`)。
- **アイコン化け**: Nerd Fontが正しく設定されているか確認してください。
