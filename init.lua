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

chat_prefix = '<S-c>'
tab_prefix = '<S-t>'

require("lazy").setup {
  { 'preservim/nerdtree' },
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
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
  { 'prabirshrestha/vim-lsp' },
  { 'mattn/vim-lsp-settings' },
  { 'prabirshrestha/asyncomplete.vim' },
  { 'prabirshrestha/asyncomplete-lsp.vim' },
  { 'mattn/vim-lsp-icons' },
  { 'hrsh7th/vim-vsnip' },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.cmd [[Lazy load markdown-preview.nvim]]
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = "main",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    {'tpope/vim-fugitive'},
    {'tpope/vim-surround'},
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
    {'prabirshrestha/vim-lsp'},
    {'mattn/vim-lsp-settings'},
    {'prabirshrestha/asyncomplete.vim'},
    {'prabirshrestha/asyncomplete-lsp.vim'},
    {'mattn/vim-lsp-icons'},
    {'hrsh7th/vim-vsnip'},
    {
        'CopilotC-Nvim/CopilotChat.nvim',
        branch = "main",
        dependencies = {
            { "github/copilot.vim" },
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        cmd = {
            "CopilotChatPromptList",
        }
    },
    {
      'mechatroner/rainbow_csv'
    }
  }
}

require('lualine').setup {
  options = { theme = 'jellybeans' }
}

local select = require('CopilotChat.select')
local commit_prompt = [[
    コミットメッセージを次の規約に従って記述してください。
    規約：
        - タイトルは最大50文字で、メッセージは72文字で折り返す。メッセージ全体をgitcommit言語でコードブロックにラップする。
        - 日本語で記述を行う
        - フォーマットは次の通りです。
        - 日本語で記載してください
            ```gitcommit
            [#{コミットタイプ}]: 変更内容の要約

            変更内容の詳細

            メッセージ
            ```

            - コミットタイプは次のいずれかです。
                - build: ビルド関連の変更
                - fix: バグ修正
                - feat: 新機能の追加、修正
                - docs: ドキュメントのみの変更
                - style: コードの意味に影響を与えない変更（空白、フォーマット、セミコロンの欠落など）
                - refactor: 既存のコードのリファクタリング
                - perf: パフォーマンスを向上させるコードの変更
                - test: テストの追加、変更、削除
                - ci: CI/CDの設定変更
                - chore: 雑用（ライブラリのアップデートなど）
            - 複数のコミットタイプを含める場合は','で区切ってください。
]]

vim.opt.runtimepath:append('~/.config/nvim/prompts')
require("CopilotChat").setup {
  window = {
    layout = 'float', -- 'vertical', 'horizontal', 'float', 'replace'
    width = 0.7, -- fractional width of parent, or absolute width in columns when > 1
    height = 0.7, -- fractional height of parent, or absolute height in rows when > 1
    -- Options below only apply to floating windows
    relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
    border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    row = nil, -- row position of the window, default is centered
    col = nil, -- column position of the window, default is centered
    title = 'Copilot Chat', -- title of chat window
    footer = nil, -- footer of chat window
    zindex = 1, -- determines if window is on top or below other floating windows
  },
  system_prompt = require('prompts.system_prompt'),
  prompts = {
    Comment = {
      prompt = '/COPILOT_EXPLAIN 選択したコードの説明をコメントとして書いてください。',
    },
    Explain = {
      prompt = '/COPILOT_EXPLAIN 選択したのコードの説明をしてください。',
    },
    Review = {
      prompt = '/COPILOT_REVIEW 選択したコードのレビューをしてください。',
      selection = function(source)
        return select.visual(source) or select.buffer(source)
      end,
    },
    ReviewStaged = {
      prompt = '/COPILOT_REVIEW コードレビューをしてください。',
      selection = function(source)
        return select.gitdiff(source, true)
      end,
    },
    Tests = {
      prompt = '/COPILOT_TESTS カーソル上のコードの詳細な単体テスト関数を書いてください。',
    },
    Fix = {
      prompt = '/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。',
    },
    Optimize = {
      prompt = '/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。',
    },
    Docs = {
      prompt = '/COPILOT_REFACTOR 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）',
    },
    DocsJa = {
      prompt = '/COPILOT_REFACTOR 選択したコードのドキュメントを日本語で書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）',
    },
    FixDiagnostic = {
      prompt = 'ファイル内の次のような診断上の問題を解決してください：',
      selection = select.diagnostics,
    },
    Commit = {
      prompt = commit_prompt,
      selection = function(source)
        return select.gitdiff(source, true)
      end,
    },
  }
}

--keybinds
--normal
keymap.set('n', 'j', 'gj')
keymap.set('n', 'k', 'gk')
keymap.set('n', 'gj', 'j')
keymap.set('n', 'gk', 'k')
keymap.set('n', '<C-j>', '<C-e>')
keymap.set('n', '<C-k>', '<C-y>')
keymap.set('n', '<C-n>', '<cmd>NERDTreeToggle<CR>')
keymap.set('n', '<C-p>', '<cmd>CopilotChatToggle<CR>')
keymap.set('n', '\\', '<cmd>FzfLua commands<CR>')
keymap.set('n', '<ESC><ESC>', '<cmd>nohlsearch<CR>')
keymap.set('n', '<Up>', '<cmd>bnext<CR>')
keymap.set('n', '<Down>', '<cmd>bprevious<CR>')
keymap.set('n', 'ZZ', '<Nop>')
keymap.set('n', 'ZQ', '<Nop>')
keymap.set('n', '<C-h><C-h>', '<cmd>LspDefinition<CR>')
keymap.set('n', '<C-h>', '<cmd>LspHover<CR>')

keymap.set('n', tab_prefix, '<Nop>')
keymap.set('n', tab_prefix .. 'n', '<cmd>tabnew<CR>')
keymap.set('n', tab_prefix .. 'e', '<cmd>tabedit<CR>')
keymap.set('n', tab_prefix .. 'q', '<cmd>tabclose<CR>')
keymap.set('n', tab_prefix .. 'l', '<cmd>tabnext<CR>')
keymap.set('n', tab_prefix .. 'h', '<cmd>tabprevious<CR>')
keymap.set('n', tab_prefix .. 'S-l', '<cmd>+tabmove<CR>')
keymap.set('n', tab_prefix .. 'S-h', '<cmd>-tabmove<CR>')

--insert
keymap.set('i', '<C-b>', '<Left>')
keymap.set('i', '<C-f>', '<Right>')
keymap.set('i', '<C-j>', '<Plug>(copilot-next)')
keymap.set('i', '<C-k>', '<Plug>(copilot-previous)')
keymap.set('i', '<C-w>', '<Plug>(copilot-accept-word)')
keymap.set('i', '<C-l>', '<Plug>(copilot-accept-line)')
keymap.set('i', '<C-r>', '<Plug>(copilot-dismiss)')
keymap.set('i', '<C-r><C-r>', '<Plug>(copilot-suggest)')
keymap.set({ 'n', 'i' }, '<C-x><C-f>',
  function() require("fzf-lua").complete_path() end,
  { silent = true, desc = "Fuzzy complete path" }
)
keymap.set({ 'n', 'i' }, '<C-x><C-i>',
  function()
    require("fzf-lua").fzf_exec("rg --files",
      { actions = { ['enter'] = function(selected, opts)
        vim.api.nvim_put(selected, "c", true, true)
      end } })
    vim.cmd("startinsert")
  end,
  { silent = true, desc = "Fuzzy insert path" }
)

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

set.laststatus  = 2
set.title       = true
set.showmode    = true
set.number      = true
set.cursorline  = true
set.undofile    = true
set.helplang    = "ja", "en"
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

-- Custom command
vim.api.nvim_create_user_command(
  'Sjis',
  function()
    vim.cmd('edit ++enc=cp932')
  end,
  {}
)
vim.api.nvim_create_user_command(
  'Utf8',
  function()
    vim.cmd('edit ++enc=utf-8')
  end,
  {}
)
vim.api.nvim_create_user_command(
  'CC',
  function()
    vim.opt.cursorcolumn = not vim.opt.cursorcolumn:get()
  end,
  {}
)
vim.api.nvim_create_user_command(
  'Filename',
  function()
    print(vim.fn.expand('%:t'))
  end,
  {}
)

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

vim.api.nvim_create_user_command('SnakeCase', function()
  convert_selection_to_case(to_snake_case)
end, { range = true })

vim.api.nvim_create_user_command('PascalCase', function()
  convert_selection_to_case(to_pascal_case)
end, { range = true })

local function copilot_chat_prompt_list()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
end

vim.api.nvim_create_user_command('CopilotChatPromptList', function()
  copilot_chat_prompt_list()
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
