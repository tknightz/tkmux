local M = {}

local function do_style(title, fg, bg, icon)
  local content = title
  if icon ~= "" and title ~= "" then
    content = " " .. icon .. "  " .. title .. " "
  end
  return string.format("#[fg=%s]#[bg=%s]%s", fg, bg, content)
end

M.do_style = do_style

local function make_style(config, section, value)
  local cfg = config.styles[section]
  local fg = config.theme.colors[cfg.fg]
  local bg = config.theme.colors[cfg.bg]
  local icon = cfg.icon
  local result = do_style(value, fg, bg, icon)

  if cfg.bold then
    result = "#[bold]" .. result .. "#[nobold]"
  end
  if cfg.italic then
    result = "#[italics]" .. result .. "#[noitalics]"
  end

  return result
end

function M.make_styles(config, values, sections, sep, right)
  sep = sep or ""
  right = right or false
  local result = {}
  local render_sections = {}

  for _, section in ipairs(sections) do
    local style = config.styles[section]
    if style and style.enabled == false then
      goto continue_build
    end
    local value = values[section]()
    if right and config.options.right_skip_empty and value == "" then
      goto continue_build
    end

    table.insert(render_sections, { name = section, value = value })
    ::continue_build::
  end

  for idx, entry in ipairs(render_sections) do
    local section = entry.name
    local value = entry.value

    local style = make_style(config, section, value)

    if sep ~= "" then
      local cfg = config.styles[section]
      local sep_fg = config.theme.colors[cfg.bg]
      local sep_bg = config.theme.colors.bg
      if not right then
        if idx == #render_sections then
          sep_bg = config.theme.colors.bg
        else
          sep_bg = config.theme.colors[config.styles[render_sections[idx + 1].name].bg]
        end
      else
        if idx == 1 then
          sep_bg = config.theme.colors.bg
        else
          sep_bg = config.theme.colors[config.styles[render_sections[idx - 1].name].bg]
        end
      end

      local style_sep = do_style(sep, sep_fg, sep_bg, "")
      if right then
        style = style_sep .. style
      else
        style = style .. style_sep
      end
    end

    if right and config.theme.separators.right_in ~= "" and idx < #render_sections then
      local cfg = config.styles[section]
      local sep_fg = config.theme.colors[cfg.bg]
      local sep_bg = config.theme.colors[config.styles[render_sections[idx + 1].name].bg]
      local inner_sep = do_style(config.theme.separators.right_in, sep_fg, sep_bg, "")
      style = style .. inner_sep
    end

    table.insert(result, style)
  end

  return table.concat(result, "")
end

return M
