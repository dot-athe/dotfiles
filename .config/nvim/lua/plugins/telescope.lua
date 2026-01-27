return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- 検索パフォーマンスを向上させるための拡張機能 (makeビルドが必要)
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    -- ファイルアイコン表示
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate" }, -- パスが長い場合に省略
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- Ctrl+k で上移動
            ["<C-j>"] = actions.move_selection_next,     -- Ctrl+j で下移動
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-x>"] = require("telescope.actions").delete_buffer, -- バッファ削除
          },
        },
      },
    })

    -- FZF拡張のロード（ビルドが成功している場合のみ）
    pcall(telescope.load_extension, "fzf")
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
