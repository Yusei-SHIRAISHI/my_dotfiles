return function()
  require("avante").setup({
    mode = 'agentic',
    provider = "copilot",
    providers = {
      copilot = {
        model = "gpt-4o",
        --model = "claude-sonnet-4",
      },
    },
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
    file_selectors = {
      provider = "fzf",
    },
    web_search_engine = {
      provider = "tavily",
      proxy = nil,
    },
    mappings = {
      sidebar = {
        switch_windows = nil,
      }
    },
    -- system_prompt as function ensures LLM always has latest MCP server state
    -- This is evaluated for every message, even in existing chats
    system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        if not hub then
            return
        end
        return hub:get_active_servers_prompt()
    end,
    -- Using function prevents requiring mcphub before it's loaded
    custom_tools = function()
        return {
            require("mcphub.extensions.avante").mcp_tool(),
        }
    end,
    })
end
