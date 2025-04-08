
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
