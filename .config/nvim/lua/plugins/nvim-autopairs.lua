return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = true,
  -- 詳細設定が必要な場合は以下のように記述
  -- config = function()
  --   require("nvim-autopairs").setup({
  --     check_ts = true, -- Treesitter連携
  --   })
  -- end
}
