-- [[ Basic Keymaps 
-- Plugin specific keymaps are found in plugin configurations. See ./lua/plugins/configs directory
-- ]]
--
local set = vim.keymap.set
local g = vim.g

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
g.mapleader = ' '
g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- movement
set({ 'n', 'v' }, 'gs', '^', { desc = 'Go to the first non-blank character of the line' })
set({ 'n', 'v' }, 'ge', '$', { desc = 'Go to the end of the word' })

-- Remap for dealing with word wrap
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- buffer movement
set('n', '<leader>bn', ':bnext<CR>', { desc =  'Move to next [B]uffer' })
set('n', '<leader>bp', ':bprev<CR>', { desc =  'Move to previous [B]uffer' })
set('n', '<leader>bd', ':bdelete<CR>', { desc =  'Close [B]uffer' })

-- window movement
set("n", "<c-j>", "<c-w>j")
set("n", "<c-h>", "<c-w>h")
set("n", "<c-k>", "<c-w>k")
set("n", "<c-l>", "<c-w>l")
set("n", "<leader>vs", ":vsplit<CR>")
set("n", "<leader>=", ":vertical resize +5<CR>")
set("n", "<leader>-", ":vertical resize -5<CR>")

-- Diagnostic keymaps
set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Netrw keymaps
set('n', '<leader>fe', ':Explore<CR>', { desc = 'Open Netrw' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
