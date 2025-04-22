return function()
  require("mcphub").setup({
    -- Server configuration
    port = 37373,                    -- Port for MCP Hub Express API
    config = vim.fn.expand("~/.config/mcphub/servers.json"), -- Config file path
    
    native_servers = {}, -- add your native servers here
    -- Extension configurations
    auto_approve = true,
    extensions = {
        avante = {
          make_slash_commands = true,
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
end
