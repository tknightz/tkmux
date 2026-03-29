local function add_module_path()
  local source = debug.getinfo(1, "S").source
  local file_path = source:gsub("^@", "")
  local dir = file_path:match("^(.*)/")
  if not dir then
    return
  end

  -- Handle both absolute paths (/home/user/tkmux/scripts) and relative paths (scripts)
  local root = dir:match("^(.*)/scripts") or (dir == "scripts" and ".")
  if root then
    local lua_path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. root .. "/lua/?/?.lua;" .. root .. "/lua/tkmux/?.lua;" .. root .. "/lua/tkmux/?/init.lua;" .. root .. "/lua/tkmux/?/?.lua;"
    if not package.path:find(lua_path, 1, true) then
      package.path = lua_path .. package.path
    end
  end
end

add_module_path()

local tkmux = require("tkmux")

local command = arg[1] or "status-left"

if command == "status-left" then
  io.write(tkmux.status_left())
elseif command == "status-right" then
  io.write(tkmux.status_right())
elseif command == "window-active" then
  io.write(tkmux.window_status("active"))
elseif command == "window-common" then
  io.write(tkmux.window_status("common"))
end
