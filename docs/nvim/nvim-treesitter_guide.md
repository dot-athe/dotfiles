# nvim-treesitter セットアップガイド

## ドキュメント

- [GitHub Repository](https://github.com/nvim-treesitter/nvim-treesitter)
- [Supported Languages](https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md)

## 概要

**nvim-treesitter** は、NeoVim に強力な構文解析機能を提供するインターフェースです。
従来の正規表現ベースのハイライトとは異なり、コードの構造を理解した上でハイライト、インデント、折りたたみ（Code Folding）を行います。

## 前提条件

- **NeoVim Version**: `v0.9.2` 以上推奨
- **Cコンパイラ**: パーサーのコンパイルに必要（`gcc` や `clang`）
  - macOSの場合: `xcode-select --install` で入ります
- **Lazy.nvim**: プラグインマネージャー

## 設定例 (lazy.nvim)

`lua/plugins/treesitter.lua` を作成し、以下のコードを記述します。

```lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      -- インストールする言語パーサーのリスト
      -- "all" も可能ですが、必要なものだけ入れるのが推奨です
      ensure_installed = {
        "bash",
        "c",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },

      -- 同期インストールを行うか (false 推奨)
      sync_install = false,

      -- 自動インストール (未知の拡張子のファイルを開いた時など)
      auto_install = true,

      highlight = {
        enable = true, -- ハイライトを有効化
        -- vimの正規表現ハイライトと併用する場合の設定（大きいファイルで重い場合に有効など）
        additional_vim_regex_highlighting = false,
      },
      
      indent = {
        enable = true, -- インデントを有効化
      },
    })
  end,
}
```

## 基本操作

- **:TSUpdate**: パーサーの更新
- **:TSInstall <language>**: 手動で言語パーサーをインストール (例: `:TSInstall rust`)
- **:TSInstallInfo**: インストール済みパーサーの一覧表示

## トラブルシューティング

- **ハイライトがおかしい**: `:TSUpdate` を試してください。
- **インデントがおかしい**: `indent = { enable = true }` が効いていない場合は、NeoVimの標準インデント設定と競合していないか確認してください。
