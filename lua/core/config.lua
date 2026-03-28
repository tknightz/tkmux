local tmux = require("core.tmux")

local M = {}

local function deep_merge(base, override)
  local result = {}
  for key, value in pairs(base or {}) do
    if type(value) == "table" then
      result[key] = deep_merge(value, {})
    else
      result[key] = value
    end
  end

  for key, value in pairs(override or {}) do
    if type(value) == "table" and type(result[key]) == "table" then
      result[key] = deep_merge(result[key], value)
    else
      result[key] = value
    end
  end

  return result
end

local function load_theme(name)
  local ok, theme = pcall(require, "themes." .. name)
  if ok and theme then
    return theme
  end
  return require("themes.default")
end

local function load_user_config()
  local ok, user_config = pcall(require, "tkmux_user")
  if ok and user_config then
    return user_config
  end
  return nil
end

local function split_list(value)
  local result = {}
  for entry in (value or ""):gmatch("[^,]+") do
    local trimmed = entry:gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed ~= "" then
      table.insert(result, trimmed)
    end
  end
  return result
end

local function apply_minimal_theme_defaults(config)
  if config.theme and config.theme.name == "minimal" then
    for _, style in pairs(config.styles or {}) do
      style.bg = "bg"
    end
  end
end

local function with_tmux_overrides(config)
  local prefix = "@tkmux_"
  local theme = config.theme

  local function opt(name, default)
    return tmux.get_option(prefix .. name, default)
  end

  theme.name = opt("theme", theme.name)

  theme.separators = theme.separators or {}
  theme.separators.left = opt("sep_left", theme.separators.left)
  theme.separators.right = opt("sep_right", theme.separators.right)
  theme.separators.right_in = opt("sep_right_in", theme.separators.right_in)

  for name, value in pairs(theme.colors or {}) do
    theme.colors[name] = opt("color_" .. name, value)
  end

  config.options.right_skip_empty = opt(
    "right_skip_empty",
    tostring(config.options.right_skip_empty)
  ) == "true"
  config.options.playing_max_len = tonumber(opt(
    "playing_max_len",
    tostring(config.options.playing_max_len)
  )) or config.options.playing_max_len

  local left_sections = opt("sections_left", "")
  local right_sections = opt("sections_right", "")
  if left_sections ~= "" then
    config.sections.left = split_list(left_sections)
  end
  if right_sections ~= "" then
    config.sections.right = split_list(right_sections)
  end

  config.options.cpu_thresholds = config.options.cpu_thresholds or {}
  config.options.cpu_thresholds.high = tonumber(opt(
    "cpu_high",
    tostring(config.options.cpu_thresholds.high or 80)
  )) or config.options.cpu_thresholds.high
  config.options.cpu_thresholds.medium = tonumber(opt(
    "cpu_medium",
    tostring(config.options.cpu_thresholds.medium or 40)
  )) or config.options.cpu_thresholds.medium

  config.options.ram_thresholds = config.options.ram_thresholds or {}
  config.options.ram_thresholds.high = tonumber(opt(
    "ram_high",
    tostring(config.options.ram_thresholds.high or 16)
  )) or config.options.ram_thresholds.high
  config.options.ram_thresholds.medium = tonumber(opt(
    "ram_medium",
    tostring(config.options.ram_thresholds.medium or 12)
  )) or config.options.ram_thresholds.medium

  for name, style in pairs(config.styles) do
    style.icon = opt(name .. "_icon", style.icon)
    style.fg = opt(name .. "_fg", style.fg)
    style.bg = opt(name .. "_bg", style.bg)
    if style.enabled ~= nil then
      style.enabled = opt(name .. "_enabled", tostring(style.enabled)) == "true"
    end
    if style.fg_default then
      style.fg_default = opt(name .. "_fg_default", style.fg_default)
    end

    if style.fg_high then
      style.fg_high = opt(name .. "_fg_high", style.fg_high)
    end
    if style.fg_medium then
      style.fg_medium = opt(name .. "_fg_medium", style.fg_medium)
    end
  end

  return config
end

function M.load()
  local base = require("defaults")
  local theme_name = tmux.get_option("@tkmux_theme", base.theme)
  local theme = load_theme(theme_name)

  local config = {
    theme = theme,
    sections = base.sections,
    window = base.window,
    options = base.options,
    styles = base.styles,
  }

  apply_minimal_theme_defaults(config)

  local user_config = load_user_config()
  if user_config then
    config = deep_merge(config, user_config)
  end

  return with_tmux_overrides(config)
end

return M
