local M = {}

M.theme = "tokyo_night"

M.sections = {
  left = { "session", "uptime" },
  right = { "playing_info", "cpu", "ram", "date", "user" },
}

M.window = {
  active = "window_active",
  common = "window",
}

M.options = {
  right_skip_empty = true,
  playing_max_len = 30,
}

M.styles = {
  session = { icon = "", fg = "black", bg = "red", bold = true },
  uptime = { icon = "", fg = "black", bg = "orange", bold = false },
  cpu = {
    icon = "",
    fg = "accent",
    fg_default = "accent",
    bg = "bg",
    fg_high = "red",
    fg_medium = "orange",
    bold = true,
  },
  playing_info = { icon = "", fg = "pink", bg = "dark", bold = true },
  date = { icon = "󰃰", fg = "accent", bg = "bg" },
  ram = {
    icon = "",
    fg = "accent",
    fg_default = "accent",
    bg = "dark_alt",
    fg_high = "red",
    fg_medium = "orange",
    bold = true,
  },
  user = { icon = "", fg = "black", bg = "red", bold = true },
  window_active = { icon = "", fg = "black", bg = "blue", bold = true },
  window = { icon = "", fg = "gray", bg = "black", italic = true },
}

return M
