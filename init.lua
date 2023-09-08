-- ~/.config/nvim/lua/init.lua

--[[
plugins
]]

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'vim', 'c', 'python', 'bash', 'lua', 'make', 'cmake', 'json', 'rust' },
    sync_install = false,
    auto_install = true,

    highlight = {
        enable = true,
        disable = { 'rust' },
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = { enable = true },
    textobjects = { enable = true },

    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
        -- colors = {},
        -- termcolors = {},
    }
}
