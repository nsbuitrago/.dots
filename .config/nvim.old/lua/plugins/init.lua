-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	require("plugins.config.mini"), -- mini plugins
	{ "echasnovski/mini.pairs", version = "*", opts = {} }, -- auto brackets
	"christoomey/vim-tmux-navigator", -- navigate between vim and tmux
	require("plugins.config.autotags"), -- autopairs for html tags
	require("plugins.config.lsp"), -- Language server protocol support
	require("plugins.config.cmp"), -- Autocompletion
	require("plugins.config.git"), -- git signs
	require("plugins.config.colors"), -- colorscheme
	require("plugins.config.blankline"), -- indentation guides
	require("plugins.config.telescope"), -- fuzzy finder
	require("plugins.config.treesitter"), -- syntax highlighting
	require("plugins.config.conform"), -- autoformatting
	require("plugins.config.oil"), -- file explorer
}, {
	performance = {
		disabled_plugins = {
			"netrwPlugin",
			"tutor",
			"tarPlugin",
			"tohtml",
			"gzip",
			"zipPlugin"
		},
	},
})
