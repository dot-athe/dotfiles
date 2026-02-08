# nvim-lspconfig 日本語ガイド

## 概要

`nvim-lspconfig` は、NeovimのLSP (Language Server Protocol) クライアントを簡単に設定するためのプラグインです。
言語サーバーごとの推奨設定を提供し、手動での設定の手間を省きます。

## 前提条件

- Neovim 0.11以上 (Mason v2.0+ 使用時)
- `mason.nvim` (言語サーバーの管理用、推奨)

## 設定例 (Lazy.nvim)

`mason-lspconfig` v2.0以降、`setup_handlers` は廃止され、Neovimネイティブの `vim.lsp.config` を使用して設定します。

```lua
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            -- Neovim 0.11+ ネイティブLSP設定
            -- サーバー個別の設定は vim.lsp.config を使用します
            if vim.lsp.config then
                 vim.lsp.config("lua_ls", {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                        },
                    },
                })
            end
            
            require("mason").setup()
            require("mason-lspconfig").setup({
                -- 自動インストール設定
                ensure_installed = { "lua_ls" },
                -- インストール済みサーバーは自動的に有効化されます (automatic_enable = true)
            })
        end,
    }
}
```

## 基本的な使い方

LSPが有効なバッファでは、サーバーの機能に応じてキーバインドが有効になります（要設定）。

| 機能 | コマンド/関数 |
| --- | --- |
| 定義ジャンプ | `vim.lsp.buf.definition()` |
| 参照検索 | `vim.lsp.buf.references()` |
| ホバー情報 | `vim.lsp.buf.hover()` |
| コードアクション | `vim.lsp.buf.code_action()` |
| リネーム | `vim.lsp.buf.rename()` |
| フォーマット | `vim.lsp.buf.format()` |

`:LspInfo` コマンドで、現在接続されているサーバーの状態を確認できます。
