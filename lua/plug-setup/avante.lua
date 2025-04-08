require("avante").setup({
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
      },
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
    file_selectors = {
      provider = "fzf",
    },
  },
})
