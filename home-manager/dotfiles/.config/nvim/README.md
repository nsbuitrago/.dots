# @NSBuitrago Neovim Config

This is my personal neovim config, mainly for Python, Rust, and Svelte development.
A lot of this config came from the awesome [kickstart.nvim repo](https://github.com/nvim-lua/kickstart.nvim).

## Contents

```bash
.
├── init.lua -> Neovim config entry point
├── README.md -> This file
└── lua/
    ├── core/
    │   ├── init.lua -> requires lua/keymaps.lua and lua/options.lua
    │   ├── keymaps.lua -> Basic keymaps
    │   └── options.lua -> Default neovim options
    └── plugins/
        ├── init.lua -> Installs plugin manager and plugins
        └── config/ -> configurations for plugins
            ├── blankline.lua
            ├── bufferline.lua
            ├── cmp.lua
            ├── colors.lua
            ├── dap.lua
            ├── git.lua
            ├── lsp.lua
            ├── lualine.lua
            ├── telescope.lua
            ├── treesitter.lua
```

This config is commented in most places if you are interested in taking a look.

## TODO:
- [x] add mini.autopairs
- [x] add keybindings for buffer nav
- [ ] add harpoon cause I love it
- [x] set showmode to false
- [x] add extra cmp plugins
- [x] add copilot support
- [x] setup autocmd to open telescope on startup if no file is given
- [x] add navigator plugin for tmux support
- [x] add bufferline
- [x] add dap stuff
- [ ] add autoformatting

