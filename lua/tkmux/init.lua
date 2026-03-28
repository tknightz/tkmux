local config_loader = require("core.config")
local renderer = require("core.renderer")
local segments = require("core.segments")

local M = {}

local function build_values(config)
  return {
    uptime = segments.uptime,
    session = segments.session,
    cpu = function()
      return segments.cpu(config)
    end,
    playing_info = function()
      return segments.playing_info(config)
    end,
    ram = function()
      return segments.ram(config)
    end,
    date = segments.date,
    user = segments.user,
    window_active = segments.window_active,
    window = segments.window,
  }
end

function M.status_left()
  local config = config_loader.load()
  local values = build_values(config)
  return renderer.make_styles(
    config,
    values,
    config.sections.left,
    config.theme.separators.left,
    false
  )
end

function M.status_right()
  local config = config_loader.load()
  local values = build_values(config)
  return renderer.make_styles(
    config,
    values,
    config.sections.right,
    config.theme.separators.right,
    true
  )
end

function M.window_status(kind)
  local config = config_loader.load()
  local values = build_values(config)
  local section = config.window.common
  if kind == "active" then
    section = config.window.active
  end

  local style = renderer.make_styles(
    config,
    values,
    { section },
    "",
    false
  )

  local bg = config.theme.colors[config.styles[section].bg]
  local lsep = renderer.do_style(config.theme.separators.left, config.theme.colors.bg, bg, "")
  local rsep = renderer.do_style(config.theme.separators.left, bg, config.theme.colors.bg, "")
  return lsep .. style .. rsep
end

return M
