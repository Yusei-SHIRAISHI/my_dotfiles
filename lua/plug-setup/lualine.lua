return function()
  require('lualine').setup {
    options = {
      disabled_filetypes = {
        winbar = {
          "Avante",
          "AvanteSelectedFiles",
          "AvanteInput",
          "fugitive",
          "neotree",
        },
      },
      theme = 'jellybeans',
    },
    sections = {
      lualine_x = {
        { require('mcphub.extensions.lualine') },
      },
    },
  }
end
