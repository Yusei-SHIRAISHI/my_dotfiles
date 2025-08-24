keymap = vim.keymap
set = vim.opt
augroup = vim.api.nvim_create_augroup
autocmd = vim.api.nvim_create_autocmd

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

local tab_prefix = '<S-t>'

require("lazy").setup {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    config = require("plug-setup.nvim-tree"),
  },
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = {
        preset = "default",
        ['<C-e>'] = { 'hide', 'show' },
      },
      sources = {
        default = { 'lsp', 'path', 'buffer'},
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = "McpHub",  -- lazy load by default
    build = "npm install -g mcp-hub@latest",  -- Installs globally
    config = require("plug-setup.mcphub"),
  },
  { 'vim-jp/vimdoc-ja' },
  { 'nanotech/jellybeans.vim' },
  { 'cohama/lexima.vim' },
  { 'junegunn/fzf', build = "./install --bin" },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("fzf-lua").setup({ { 'fzf-vim' } })
    end
  },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-surround' },
  { 'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require("plug-setup.lualine"),
  },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    config = require("plug-setup.avante"),
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "ibhagwan/fzf-lua", -- for file_selector provider fzf

      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      {
        'zbirenbaum/copilot.lua',
        event = 'InsertEnter',
        opts = {
          panel = {
            enabled = false,
          },
          suggestion = {
            auto_trigger = true,
            hide_during_completion = false,
            keymap = {
              accept = '<Tab>',
            },
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    'mechatroner/rainbow_csv',
    ft = { 'csv' },
  },
}

require("mason").setup()
require("mason-lspconfig").setup()

require('fzf-lua').register_ui_select()

--keybinds
vim.g.mapleader = ' '
--normal
keymap.set('n', 'j', 'gj')
keymap.set('n', 'k', 'gk')
keymap.set('n', 'gj', 'j')
keymap.set('n', 'gk', 'k')
keymap.set('n', '<C-j>', '<C-e>')
keymap.set('n', '<C-k>', '<C-y>')
keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>')
keymap.set('n', '\\', '<cmd>FzfLua commands<CR>')
keymap.set('n', '<ESC><ESC>', '<cmd>nohlsearch<CR>')
keymap.set('n', '<Up>', '<cmd>bnext<CR>')
keymap.set('n', '<Down>', '<cmd>bprevious<CR>')
keymap.set('n', 'ZZ', '<Nop>')
keymap.set('n', 'ZQ', '<Nop>')
keymap.set('n', '<C-h><C-h>', '<cmd>lua vim.lsp.buf.definition()<CR>')
keymap.set('n', '<C-h>', '<cmd>lua vim.lsp.buf.hover()<CR>')

keymap.set('n', tab_prefix, '<Nop>')
keymap.set('n', tab_prefix .. 'n', '<cmd>tabnew<CR>')
keymap.set('n', tab_prefix .. 'e', '<cmd>tabedit<CR>')
keymap.set('n', tab_prefix .. 'q', '<cmd>tabclose<CR>')
keymap.set('n', tab_prefix .. 'l', '<cmd>tabnext<CR>')
keymap.set('n', tab_prefix .. 'h', '<cmd>tabprevious<CR>')
keymap.set('n', tab_prefix .. 'S-l', '<cmd>+tabmove<CR>')
keymap.set('n', tab_prefix .. 'S-h', '<cmd>-tabmove<CR>')

--insert
keymap.set('i', '<C-f>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").next()
  end
end, { expr = false, silent = true })

keymap.set('i', '<C-b>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").prev()
  end
end, { expr = false, silent = true })

keymap.set('i', '<C-w>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept_word()
  end
end, { expr = false, silent = true })

keymap.set('i', '<C-l>', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept_line()
  end
end, { expr = false, silent = true })

keymap.set('i', '<C-r>r', function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").dismiss()
  end
end, { expr = false, silent = true })

keymap.set('i', '<C-r>', function()
  require("copilot.suggestion").toggle_auto_trigger()
end, { expr = false, silent = true })

--visual
keymap.set('v', '<C-j>', '<C-e>')
keymap.set('v', '<C-k>', '<C-y>')
keymap.set('v', '\\', '<cmd>FzfLua commands<CR>')

--command
keymap.set('c', '<C-p>', '<C-r>')
keymap.set('c', '<C-f>', '<Right>')
keymap.set('c', '<C-b>', '<Left>')

--terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>')

set.laststatus  = 3
set.title       = true
set.showmode    = true
set.number      = true
set.cursorline  = true
set.undofile    = true
set.helplang    = { "ja", "en" }
set.showmatch   = true
set.mouse       = ""
set.showtabline = 2
set.tabstop     = 2
set.expandtab   = true
set.shiftwidth  = 2
set.autoindent  = true
set.smartindent = true
set.diffopt     = 'vertical'
set.showcmd     = true
set.ignorecase  = true
set.smartcase   = true
set.ambiwidth   = 'double'
set.wildmenu    = true
set.wildmode    = 'longest', 'full'
set.wrapscan    = true
set.hlsearch    = true
set.incsearch   = true
set.clipboard   = { 'unnamedplus', 'unnamed' }
set.ruler       = true
set.pumheight   = 10
set.infercase   = true
set.splitright  = true

vim.cmd [[colorscheme jellybeans]]
vim.cmd [[highlight NormalFloat guibg=#151515]]

local term_open = augroup("term_open", { clear = true })
autocmd('TermOpen', {
  group = term_open,
  pattern = '',
  command = 'startinsert'
})
autocmd('TermOpen', {
  group = term_open,
  pattern = '*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})

-- 全角スペースのハイライト設定
vim.api.nvim_set_hl(0, "FullWidthSpace", {
  underline = true,
  cterm = underline,
  ctermfg = 199,
  gui = underline,
  guifg = White,
})
local full_width_space = augroup("full_width_space", { clear = true })
autocmd({ "VimEnter", "WinEnter" }, {
  group = full_width_space,
  pattern = "*",
  callback = function()
    vim.fn.matchadd('FullWidthSpace', '　')
  end
})

-- 末尾スペースのハイライト設定
vim.api.nvim_set_hl(0, "EndSpace", {
  ctermbg = 199,
  guibg = Cyan,
})
local end_space = augroup("end_space", { clear = true })
autocmd({ "VimEnter", "WinEnter" }, {
  group = end_space,
  pattern = "*",
  callback = function()
    vim.fn.matchadd('EndSpace', "\\s\\+$")
  end
})


local function to_snake_case(str)
  return str:gsub("(%l)(%u)", "%1_%2"):gsub("%s+", "_"):lower()
end

local function to_pascal_case(str)
  return (str:gsub("[%s_]+", " "):gsub("%f[%a]%a+", function(word)
    return word:sub(1, 1):upper() .. word:sub(2):lower()
  end):gsub("%s+", ""))
end

local function convert_selection_to_case(case_converter)
  -- 選択範囲を取得
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))

  -- 選択範囲が複数行にわたる場合の処理
  local lines = vim.api.nvim_buf_get_lines(0, csrow - 1, cerow, false)
  if #lines == 1 then
    -- 単一行の場合
    lines[1] = lines[1]:sub(cscol, cecol)
  else
    -- 複数行の場合
    lines[1] = lines[1]:sub(cscol)
    lines[#lines] = lines[#lines]:sub(1, cecol)
  end
  local selection = table.concat(lines, "\n")

  -- ケース変換
  local converted_str = case_converter(selection)

  -- 選択範囲を変換後の文字列で置換
  if #lines == 1 then
    -- 単一行の場合
    vim.api.nvim_buf_set_text(0, csrow - 1, cscol - 1, csrow - 1, cscol - 1 + #selection, { converted_str })
  else
    -- 複数行の場合、最初と最後の行で特別な処理が必要
    local first_line = vim.api.nvim_buf_get_lines(0, csrow - 1, csrow, false)[1]
    local prefix = first_line:sub(1, cscol - 1)
    local last_line = vim.api.nvim_buf_get_lines(0, cerow - 1, cerow, false)[1]
    local suffix = last_line:sub(cecol + 1)
    local converted_lines = vim.split(converted_str, "\n", true)
    converted_lines[1] = prefix .. converted_lines[1]
    converted_lines[#converted_lines] = converted_lines[#converted_lines] .. suffix

    -- 元の選択範囲を削除し、変換後のテキストを挿入
    vim.api.nvim_buf_set_lines(0, csrow - 1, cerow, false, converted_lines)
  end
end

-- Custom command
vim.api.nvim_create_user_command('Sjis', function()
  vim.cmd('edit ++enc=cp932')
end, {})

vim.api.nvim_create_user_command('Utf8', function()
  vim.cmd('edit ++enc=utf-8')
end, {})

vim.api.nvim_create_user_command('CC', function()
  vim.opt.cursorcolumn = not vim.opt.cursorcolumn:get()
end, {})

vim.api.nvim_create_user_command('Filename', function()
  print(vim.fn.expand('%:t'))
end, {})

vim.api.nvim_create_user_command('SnakeCase', function()
  convert_selection_to_case(to_snake_case)
end, { range = true })

vim.api.nvim_create_user_command('PascalCase', function()
  convert_selection_to_case(to_pascal_case)
end, { range = true })

vim.api.nvim_create_user_command('B', function()
  require('fzf-lua').buffers()
end, {})

vim.api.nvim_create_user_command('F', function()
  require('fzf-lua').files()
end, {})

vim.api.nvim_create_user_command('Rename', function()
    vim.lsp.buf.rename()
end, {})

-- WSL clipboard
if os.getenv("WSL_DISTRO_NAME") ~= nil then
  local clip = 'iconv -t sjis | clip.exe'
  if vim.fn.executable('iconv') == 1 and vim.fn.executable('clip.exe') == 1 then
    local grp = augroup("wsl_yank", { clear = true })
    autocmd("TextYankPost", {
      group = grp,
      pattern = '*',
      callback = function()
        vim.fn.system(clip, vim.fn.getreg('"'))
      end,
    })
  end
end

vim.g.asyncomplete_auto_popup = 0
vim.g.lsp_log_verbose = 1
vim.g.lsp_log_file = vim.fn.stdpath('cache') .. '/lsp.log'
vim.g.lsp_diagnostics_enabled = 0
vim.g.lsp_document_highlight_enabled = 0

