-- ~/.config/nvim/lua/init.lua
-- %LOCALAPPDATA%/nvim/lua/init.lua

--[[
plugins
]]

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = {
        'vim', 'python', 'c', 'make',
        'bash', 'lua', 'cmake', 'json', 'rust',
        'comment',
    },
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

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<cr>')
vim.keymap.set('n', '<C-w>n', ':NvimTreeFocus<cr>')
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
})
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
vim.api.nvim_create_autocmd('QuitPre', {
    callback = function()
        local tree_wins = {}
        local floating_wins = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
            local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
            if bufname:match('NvimTree_') ~= nil then
                table.insert(tree_wins, w)
            end
            if vim.api.nvim_win_get_config(w).relative ~= '' then
                table.insert(floating_wins, w)
            end
        end
        if 1 == #wins - #floating_wins - #tree_wins then
            for _, w in ipairs(tree_wins) do
                vim.api.nvim_win_close(w, true)
            end
        end
    end,
})

--- nvim-web-devicons
require("nvim-web-devicons").setup {}
