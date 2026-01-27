return {
  "nvim-treesitter/nvim-treesitter",
  version = "*",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter.configs").setup({
      -- インストールする言語パーサーのリスト
      ensure_installed = {
        "bash",
        "css",
        "csv",
        "dockerfile",
        "go",
        "http",
        "javascript",
        "jq",
        "json",
        "lua",
        "markdown",
        "prisma",
        "regex",
        "sql",
        "ssh_config",
        "tsx",
        "typescript",
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
