--[[ Configure statusline ]]
return {
  'nvim-lualine/lualine.nvim',
  config = function()
      require('lualine').setup({
      -- See `:help lualine.txt`
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_x = {"encoding", "filetype"}
        }
      })
  end
}
