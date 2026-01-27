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
    { "<leader>q", "<cmd>Neotree focus<cr>", desc = "Focus Explorer" },
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