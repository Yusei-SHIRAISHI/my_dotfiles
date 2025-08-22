return function()
  require('nvim-tree').setup({
    filters = {
      dotfiles = true,
      custom = { ".DS_Store", "thumbs.db" },
      exclude = {},
    },
    renderer = {
      icons = {
        glyphs = {
          git = {
            untracked = "?",
          },
        },
      },
    },
  })
end

