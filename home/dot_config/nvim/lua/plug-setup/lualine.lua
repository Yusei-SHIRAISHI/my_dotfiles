local function mcphub_lualine_component()
  if not vim.g.loaded_mcphub then
    return "󰐻 -"
  end

  local status = vim.g.mcphub_status or "stopped"
  if status == "stopped" then
    return "󰐻 -"
  end

  if vim.g.mcphub_executing or status == "starting" or status == "restarting" then
    local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local frame = math.floor(vim.loop.now() / 100) % #frames + 1
    return "󰐻 " .. frames[frame]
  end

  local count = vim.g.mcphub_servers_count or 0
  return "󰐻 " .. count
end

return function()
  require('lualine').setup {
    options = {
      disabled_filetypes = {
        winbar = {
          "fugitive",
          "neotree",
        },
      },
      theme = 'jellybeans',
    },
    sections = {
      lualine_x = {
        { mcphub_lualine_component },
      },
    },
  }
end
