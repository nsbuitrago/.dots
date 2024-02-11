-- [[ Configure colorscheme ]]
return {
  'sainnhe/gruvbox-material',
  priority = 1000,
  config = function()
    vim.cmd("let g:gruvbox_material_background = 'hard'")
    vim.cmd("colorscheme gruvbox-material")
  end
}
