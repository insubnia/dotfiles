-- INFO: https://neovim.io/doc/user/lua-guide.html or :help lua-guide
-- ~/.config/nvim/lua/init.lua
-- %LOCALAPPDATA%/nvim/lua/init.lua
local vim = vim
local keyset = vim.keymap.set

--[[ SETTINGS ]]
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
local os_name = vim.loop.os_uname().sysname
if os_name == "Darwin" or os_name == "Linux" then
  local handle = io.popen("which python3")
  if handle then
    local result = handle:read("*l") or ""
    handle:close()
    vim.g.python3_host_prog = result
  end
elseif os_name:match("Windows") then
  vim.g.python3_host_prog = "C:/Python312/python"
end

--[[ PLUGINS ]]
-- lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"  -- ~/.local/share/nvim
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
local rtp_before_lazy = vim.opt.rtp:get() -- NOTE: workaround for using lazy and vim-plug together
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  { "neovim/nvim-lspconfig" },
  { "nvim-tree/nvim-tree.lua", lazy = false, dependencies = { "nvim-tree/nvim-web-devicons" } },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    dependencies = { -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Extra-modules-and-plugins
      "nvim-treesitter/nvim-treesitter-context",
    },
  },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "hiphish/rainbow-delimiters.nvim" },
  { "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npx --yes yarn install",
    init = function ()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
})
vim.opt.rtp:append(rtp_before_lazy)

-- nvim-treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "vim",
    "python",
    "c",
    "cpp",
    "make",
    "bash",
    "lua",
    "cmake",
    "json",
    "rust",
    "comment",
  },
  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    disable = { "rust" },
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
  },
})

-- nvim-treesitter-context
require("treesitter-context").setup({
  enable = true,
  multiwindow = false,
  max_lines = 0,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = "outer",
  mode = "cursor",
  separator = nil,
  zindex = 20,
  on_attach = nil,
})

-- nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
keyset("n", "<C-n>", ":NvimTreeToggle<cr>")
keyset("n", "<C-w>n", ":NvimTreeFocus<cr>")
keyset("n", "<C-w><C-n>", ":NvimTreeFocus<cr>")
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
      "pyrightconfig.json",
    },
    exclude = {
      "build",
    },
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")
    api.config.mappings.default_on_attach(bufnr) -- restore default mappings

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
    vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
  end,
})
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local tree_wins = {}
    local floating_wins = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
        table.insert(tree_wins, w)
      end
      if vim.api.nvim_win_get_config(w).relative ~= "" then
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

-- nvim-autopairs
local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
npairs.add_rules({
  Rule("/*", "*/", { "c", "cpp" }),
  Rule('f"', '"', "python"):with_move(function(opts)
    return opts.char == '"'
  end),
  Rule("f'", "'", "python"):with_move(function(opts)
    return opts.char == "'"
  end)
})
npairs.setup({
  fast_wrap = {
    map = '<C-]>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = [=[[%'%"%>%]%)%}%,]]=],
    end_key = '$',
    before_key = 'h',
    after_key = 'l',
    cursor_pos_before = true,
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    manual_position = true,
    highlight = 'Search',
    highlight_grey = 'Comment'
  },
})

-- rainbow-delimiters
require("rainbow-delimiters.setup").setup({
  strategy = {},
  query = {
    [""] = "rainbow-delimiters",
    lua = "rainbow-blocks",
  },
})

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
local hooks = require("ibl.hooks")
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
vim.g.rainbow_delimiters = { highlight = highlight }

require("ibl").setup({
  indent = {},
  whitespace = {},
  scope = {
    enabled = true,
    highlight = highlight,
  },
})

-- nvim-web-devicons
require("nvim-web-devicons").setup({})

-- todo-comments
require("todo-comments").setup({
  signs = false,
  highlight = {
    before = "",
    keyword = "wide",
    after = "fg",
  },
})

--[[ nvim-lspconfig ]]
-- INFO: :help lspconfig-all
