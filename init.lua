-- INFO: https://neovim.io/doc/user/lua-guide.html or :help lua-guide
-- ~/.config/nvim/lua/init.lua
-- %LOCALAPPDATA%/nvim/lua/init.lua
local vim = vim
local keyset = vim.keymap.set

--[[ PLUGINS ]]
-- NOTE: https://github.com/junegunn/vim-plug
-- local Plug = vim.fn['plug#']
-- vim.call('plug#begin')
-- Plug('nvim-tree/nvim-tree.lua')
-- Plug('nvim-tree/nvim-web-devicons')
-- Plug('neoclide/coc.nvim', { ['branch'] = 'release' })
-- Plug('nvim-treesitter/nvim-treesitter', { ['do'] = 'TSUpdate' })
-- Plug('p00f/nvim-ts-rainbow')
-- vim.call('plug#end')


-- CoC
vim.g.coc_config_home = '~/workspace/dotfiles/vim'
vim.g.coc_global_extensions = {
    'coc-vimlsp',
    'coc-clangd',
    'coc-clang-format-style-options',
    'coc-cmake',
    'coc-json',
    'coc-prettier',
    'coc-pyright',
    'coc-snippets',
    'coc-ultisnips',
    'coc-lua',
    'coc-sh',
    'coc-tsserver',
    'coc-xml',
}
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})
function ToggleOutline()
    local res = vim.fn["coc#window#find"]("cocViewId", "OUTLINE")
    if res == -1 then
        vim.fn["CocActionAsync"]("showOutline", 1)
    else
        vim.fn["CocActionAsync"]("hideOutline", 1)
    end
end

keyset("n", "T", ":lua ToggleOutline()<CR>", { silent = true, nowait = true })
keyset("n", "J", "<Plug>(coc-diagnostic-next)", { silent = true })
keyset("n", "K", "<Plug>(coc-diagnostic-prev)", { silent = true })
keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })
keyset("n", "ge", "<Plug>(coc-rename)", { silent = true })
keyset("n", "gl", "<Plug>(coc-codeaction)", { silent = true })
keyset("n", "<leader>l", "<Plug>(coc-format)", { silent = true })
keyset("v", "<leader>l", "<Plug>(coc-format-selected)", { silent = true })
keyset("n", "?", ":CocList -I symbols<cr>", { silent = true, nowait = true })
keyset("n", ";", ":call CocAction('doHover')<cr>", { silent = true, nowait = true })

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
keyset('n', '<C-n>', ':NvimTreeToggle<cr>')
keyset('n', '<C-w>n', ':NvimTreeFocus<cr>')
keyset('n', '<C-w><C-n>', ':NvimTreeFocus<cr>')
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        enable = true,
        dotfiles = true,
        custom = {
            'pyrightconfig.json',
        },
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

-- nvim-web-devicons
require("nvim-web-devicons").setup {}
