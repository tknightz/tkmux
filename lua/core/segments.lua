local M = {}

local function shell(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return ""
  end
  local result = handle:read("*a") or ""
  handle:close()
  result = result:gsub("^%s+", ""):gsub("%s+$", "")
  return result
end

function M.uptime()
  return shell("uptime | sed -E 's/^[^,]*up *//; s/,.*//; s/([[:digit:]]+):0?([[:digit:]]+).*$/\\1h \\2min/'")
end

function M.session()
  return "#S"
end

function M.cpu(config)
  config.styles.cpu.fg = config.styles.cpu.fg_default or config.styles.cpu.fg
  local usage = tonumber(shell("bash -c \"awk '{u=\\$2+\\$4; t=\\$2+\\$4+\\$5; if (NR==1){u1=u; t1=t;} else printf \\\"%d\\\", (\\$2+\\$4-u1) * 100 / (t-t1); }' <(grep 'cpu ' /proc/stat) <(sleep 1;grep 'cpu ' /proc/stat)\""))

  local thresholds = config.options.cpu_thresholds or {}
  local high = thresholds.high or 80
  local medium = thresholds.medium or 40

  if usage then
    if usage > high then
      config.styles.cpu.fg = config.styles.cpu.fg_high
    elseif usage > medium then
      config.styles.cpu.fg = config.styles.cpu.fg_medium
    else
      config.styles.cpu.fg = "blue"
    end
    return tostring(usage) .. "%"
  end

  return "0%"
end

function M.playing_info(config)
  local raw_metadata = shell("playerctl metadata -a -f '{{lc(status)}}: {{title}} - {{artist}}' 2>&1")
  if raw_metadata == "No players found" then
    return ""
  end

  for line in raw_metadata:gmatch("[^\n]+") do
    if line:match("^playing") then
      local song_title = line:gsub("^playing: ", "")
      if #song_title > config.options.playing_max_len then
        song_title = song_title:sub(1, config.options.playing_max_len) .. "…"
      end
      return song_title
    end
  end

  return ""
end

function M.ram(config)
  config.styles.ram.fg = config.styles.ram.fg_default or config.styles.ram.fg
  local usage = tonumber(shell("free -m | awk 'NR==2 {print substr( $3 / 1000, 1, 3 )}'"))

  local thresholds = config.options.ram_thresholds or {}
  local high = thresholds.high or 16
  local medium = thresholds.medium or 12
  if usage then
    if usage > high then
      config.styles.ram.fg = config.styles.ram.fg_high
    elseif usage > medium then
      config.styles.ram.fg = config.styles.ram.fg_medium
    else
      config.styles.ram.fg = "green"
    end
    return tostring(usage) .. "Gb"
  end

  return "0Gb"
end

function M.date()
  return os.date("%H:%M - %d/%m")
end

function M.user()
  return shell("whoami")
end

function M.window_active()
  return "#W "
end

function M.window()
  return "#W "
end

return M
