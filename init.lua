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
    'coc-highlight',
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
function ToggleOutline()  -- FIXME: not work as expected
    local winid = vim.fn["coc#window#find"]("cocViewId", "OUTLINE")
    if winid == -1 then
        vim.fn["CocActionAsync"]("showOutline", 1)
    else
        -- vim.fn["CocActionAsync"]("hideOutline", 1)
        vim.fn["coc#window#close"](winid)
    end
end

keyset("n", "T", ":call CocAction('showOutline')<cr>", { silent = true, nowait = true })
-- keyset("n", "T", ":lua ShowOutline()<CR>", { silent = true, nowait = true })
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
        'vim', 'python', 'c', 'cpp', 'make',
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

-- nvim-treesitter-context
require('treesitter-context').setup {
    enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false,      -- Enable multiwindow support.
    max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20,     -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
keyset('n', '<C-n>', ':NvimTreeToggle<cr>')
keyset('n', '<C-w>n', ':NvimTreeFocus<cr>')
keyset('n', '<C-w><C-n>', ':NvimTreeFocus<cr>')
require('nvim-tree').setup({
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
        exclude = {
            'build'
        },
    },
    on_attach = function(bufnr)
        local api = require('nvim-tree.api')
        api.config.mappings.default_on_attach(bufnr) -- restore default mappings

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set('n', '?', api.tree.toggle_help, opts("Help"))
    end,
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

-- rainbow-delimiters
vim.g.rainbow_delimiters = {
    strategy = {},
    query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
    },
}

-- indent-blankline
local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require('ibl.hooks')
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
-- vim.g.rainbow_delimiters = { highlight = highlight }
require('ibl').setup {
    indent = {},
    whitespace = {},
    scope = {
        highlight = highlight
    }
}

-- nvim-web-devicons
require("nvim-web-devicons").setup {}
