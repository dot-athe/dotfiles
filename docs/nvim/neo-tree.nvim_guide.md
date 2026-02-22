# neo-tree.nvim セットアップガイド

## ドキュメント
- [GitHub Repository](https://github.com/nvim-neo-tree/neo-tree.nvim)

## 概要
**neo-tree.nvim** は、NeoVim 用の次世代ファイルエクスプローラープラグインです。
従来の `NERDTree` などに代わるもので、ファイルツリー、バッファリスト、Gitステータスなどを統合的に管理できます。Nerd Fontのアイコンを活用したリッチなUIが特徴です。

## 前提条件
- **NeoVim Version**: `v0.9.0` 以上 (推奨)
- **Lazy.nvim**: プラグインマネージャーとしてインストール済みであること
- **Nerd Font**: アイコン表示のためにインストール済みであること (`font-jetbrains-mono-nerd-font` など)

## 設定例 (lazy.nvim)
`lua/plugins/neo-tree.nvim` などのファイルを作成し、以下のコードを記述してください。

```lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- ファイルアイコン用
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
    { "<leader>b", "<cmd>Neotree focus<cr>", desc = "Focus Explorer" },
  },
  opts = {
    close_if_last_window = true, -- Neo-tree以外が閉じたら終了
    filesystem = {
      follow_current_file = {
        enabled = true, -- 開いているファイルを選択状態にする
      },
      filtered_items = {
        visible = true, -- 隠しファイルを表示設定にするか
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      width = 30, -- ウィンドウの幅
    },
  },
}
```

## 基本操作一覧

### エクスプローラー操作
| キー | アクション | 説明 |
| :--- | :--- | :--- |
| `<CR>` または `l` | open | ファイルを開く / ディレクトリを展開 |
| `<Space>e` | toggle | エクスプローラーの表示/非表示 (上記設定例) |
| `h` | close_node | ディレクトリを閉じる |
| `a` | add | 新規ファイル/ディレクトリ作成 (末尾`/`でディレクトリ) |
| `d` | delete | ファイル/ディレクトリ削除 |
| `r` | rename | 名前変更 |
| `c` | copy | コピー |
| `m` | move | 移動 |
| `q` | close_window | エクスプローラーウィンドウを閉じる |
| `?` | show_help | 操作ヘルプを表示 |

### 補足
- `<Space>e` は設定例で追加したキーバインドです。好みで変更してください。
- ファイル操作時、`y` でファイル名をクリップボードにコピーなどの機能もあります。
