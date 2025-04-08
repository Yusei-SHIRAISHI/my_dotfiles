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
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require('neo-tree').setup({
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
          indent = {
            padding = 0,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
          },
        },
        window = {
          position = "left",
          width = 40,
          mappings = {
            ["<space>"] = "toggle_node",
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["C"] = "close_node",
            ["R"] = "refresh",
            ["a"] = "add",
            ["d"] = "delete",
            ["r"] = "rename",
            ["c"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["q"] = "close_window",
          },
        },
        -- system_prompt as function ensures LLM always has latest MCP server state
        -- This is evaluated for every message, even in existing chats
        system_prompt = function()
          local success, hub = pcall(require("mcphub").get_hub_instance)
          if success and hub then
              return hub:get_active_servers_prompt()
          else
              vim.notify("Failed to get hub instance", vim.log.levels.ERROR)
              return ""
          end
        end,
        -- Using function prevents requiring mcphub before it's loaded
        custom_tools = function()
            return {
                require("mcphub.extensions.avante").mcp_tool(),
            }
        end,
        filesystem = {
          commands = {
            avante_add_files = function(state)
              local node = state.tree:get_node()
              local filepath = node:get_id()
              local relative_path = require('avante.utils').relative_path(filepath)

              local sidebar = require('avante').get()

              local open = sidebar:is_open()
              -- ensure avante sidebar is open
              if not open then
                require('avante.api').ask()
                sidebar = require('avante').get()
              end

              sidebar.file_selector:add_selected_file(relative_path)

              -- remove neo tree buffer
              if not open then
                sidebar.file_selector:remove_selected_file('neo-tree filesystem [1]')
              end
            end,
          },
          window = {
            mappings = {
              ['oa'] = 'avante_add_files',
            },
          },
          filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_by_name = {
              ".DS_Store",
              "thumbs.db",
            },
            never_show = {
              ".DS_Store",
              "thumbs.db",
            },
          },
          follow_current_file = true,
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
        },
        buffers = {
          follow_current_file = true,
        },
        git_status = {
          window = {
            position = "float",
          },
        },
      })
    end
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    cmd = "MCPHub",  -- lazy load by default
    build = "npm install -g mcp-hub@latest",  -- Installs globally
    config = function()
        require("mcphub").setup({
            -- Server configuration
            port = 37373,                    -- Port for MCP Hub Express API
            config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Config file path
            
            native_servers = {}, -- add your native servers here
            -- Extension configurations
            auto_approve = true,
            extensions = {
                avante = {
                    
                },
            },
            
            -- UI configuration
            ui = {
                window = {
                    width = 0.8,      -- Window width (0-1 ratio)
                    height = 0.8,     -- Window height (0-1 ratio)
                    border = "rounded", -- Window border style
                    relative = "editor", -- Window positioning
                    zindex = 50,      -- Window stack order
                },
            },
            
            -- Event callbacks
            on_ready = function(hub) end,  -- Called when hub is ready
            on_error = function(err) end,  -- Called on errors
            
            -- Logging configuration
            log = {
                level = vim.log.levels.WARN,  -- Minimum log level
                to_file = false,              -- Enable file logging
                file_path = nil,              -- Custom log file path
                prefix = "MCPHub"             -- Log message prefix
            }
        })
    end,
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
    "yetone/avante.nvim",
    enabled = true,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      behaviour = {
        auto_suggestions = true,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = true,
      },
      windows = {
        position = "right",
        width = 30,
        sidebar_header = {
          align = "center",
          rounded = false,
        },
        ask = {
          floating = true,
          start_insert = false,
          border = "rounded"
        }
      },
      copilot = {
        endpoint = "https://api.githubcopilot.com",
        model = "gpt-4o-2024-08-06",
        proxy = nil, -- [protocol://]host[:port] Use this proxy
        allow_insecure = false, -- Allow insecure server connections
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0,
        max_tokens = 20480,
      },
    },
    file_selectors = {
      provider = "fzf",
    },
    web_search_engine = {
      provider = "tavily",
      proxy = nil,
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
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

require('lualine').setup {
  options = { theme = 'jellybeans' }
}

require("copilot").setup({
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = "<Tab>",
      accept_word = "<C-w>",
      accept_line = "<C-l>",
      next = "<C-j>",
      prev = "<C-k>",
      toggle_auto_trigger = "<C-r>"
    },
  },
  filetypes = {
    ["*"] = true
  }
})

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
keymap.set('n', '<C-n>', '<cmd>Neotree toggle<CR>')
keymap.set('n', '<C-p>', '<cmd>AvanteToggle<CR>')
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
-- insert file path use fuzzy find
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

vim.api.nvim_create_user_command('B', function()
  require('fzf-lua').buffers()
end, {})

vim.api.nvim_create_user_command('F', function()
  require('fzf-lua').files()
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
