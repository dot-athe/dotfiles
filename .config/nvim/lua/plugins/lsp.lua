return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Configure lua_ls using native vim.lsp.config (Neovim 0.11+)
			if vim.lsp.config then
				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				})

				-- React / TypeScript
				vim.lsp.config("ts_ls", {})
				vim.lsp.config("eslint", {
					on_attach = function(_, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								-- Try to run EslintFixAll, ignore errors
								pcall(vim.cmd, "EslintFixAll")
							end,
						})
					end,
				})

				-- Go
				vim.lsp.config("gopls", {
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
							},
							staticcheck = true,
						},
					},
				})
			end

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "ts_ls", "eslint", "gopls" },
				-- automatic_installation is removed in v2.0
				-- automatic_enable is true by default
			})
		end,
	},
}
