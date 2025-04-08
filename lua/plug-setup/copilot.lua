
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

