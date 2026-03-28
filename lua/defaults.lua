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
  cpu_thresholds = {
    high = 80,
    medium = 40,
  },
  ram_thresholds = {
    high = 16,
    medium = 12,
  },
}

M.styles = {
  session = { icon = "", fg = "black", bg = "red", bold = true, enabled = true },
  uptime = { icon = "", fg = "black", bg = "orange", bold = false, enabled = true },
  cpu = {
    icon = "",
    fg = "accent",
    fg_default = "accent",
    bg = "bg",
    fg_high = "red",
    fg_medium = "orange",
    bold = true,
    enabled = true,
  },
  playing_info = { icon = "", fg = "pink", bg = "dark", bold = true, enabled = true },
  date = { icon = "󰃰", fg = "accent", bg = "bg", enabled = true },
  ram = {
    icon = "",
    fg = "accent",
    fg_default = "accent",
    bg = "dark_alt",
    fg_high = "red",
    fg_medium = "orange",
    bold = true,
    enabled = true,
  },
  user = { icon = "", fg = "black", bg = "red", bold = true, enabled = true },
  window_active = { icon = "", fg = "black", bg = "blue", bold = true, enabled = true },
  window = { icon = "", fg = "gray", bg = "black", italic = true, enabled = true },
}

return M
