# Mason.nvim 日本語ガイド

## 概要

`mason.nvim` は、LSPサーバー、DAPサーバー、リンター、フォーマッターなどの外部ツールをNeovimから簡単にインストール・管理するためのパッケージマネージャーです。
OSごとのインストールコマンド（npm, pip, go install等）を意識せずにツールを導入できます。

## 前提条件

- Neovim 0.7以上
- `git`, `curl` or `wget`
- インストールするツールに応じたランタイム (例: Node.js, Python, Go, Rust等)

## 設定例 (LSP連携)

```lua
return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- 初回起動時にレジストリを更新
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                -- 自動インストールしたいサーバーをリストアップ
                ensure_installed = { "lua_ls", "bashls", "jsonls" },
                -- v2.0以降、インストールされたサーバーは自動的に有効化されます
            })
        end
    }
}
```

## 基本操作

- `:Mason` : 管理画面を開きます。
  - `i` : 選択したツールをインストール
  - `U` : パッケージをアップデート
  - `X` : パッケージをアンインストール
  - `/` : パッケージの検索
- `:MasonUpdate` : レジストリを更新します。

## 補足

`mason-lspconfig.nvim` は、`mason.nvim` と `nvim-lspconfig` を繋ぐためのブリッジプラグインです。
Masonでインストールしたサーバーを、手動でPATHを通すことなく `lspconfig` から使えるようにしてくれます。
