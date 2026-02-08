# nvim-cmp 日本語ガイド

## 概要
`nvim-cmp` は、Neovim用の自動補完プラグインです。
LSP、バッファ、パス、スニペットなど、様々なソースからの候補を統合して表示します。
拡張性が高く、見た目や挙動を細かくカスタマイズ可能です。

## 前提条件
- Neovim
- スニペットエンジン (数種類から選択可能だが、`LuaSnip` が推奨されることが多い)

## 設定例

```lua
return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter", -- インサートモードに入った時に読み込み
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- LSPソース
            "hrsh7th/cmp-buffer",   -- バッファ内単語
            "hrsh7th/cmp-path",     -- ファイルパス
            "L3MON4D3/LuaSnip",     -- スニペットエンジン
            "saadparwaiz1/cmp_luasnip", -- Snippetソース
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(), -- 補完ウィンドウを手動表示
                    ["<C-e>"] = cmp.mapping.abort(),      -- 補完をキャンセル
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- 決定
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "path" },
                }),
            })
        end,
    },
}
```

## 主なキーバインド (上記設定例の場合)
- `<Tab>` / `<S-Tab>` : 候補の選択、スニペットのジャンプ
- `<CR>` : 候補の確定
- `<C-Space>` : 補完メニューの強制表示

## 補足
- `sources` の順序は優先順位に影響します。
- `formatting` オプションを使うと、補完メニューにアイコンを表示するなどの見た目のカスタマイズが可能です（`lspkind.nvim` 等を使用）。
