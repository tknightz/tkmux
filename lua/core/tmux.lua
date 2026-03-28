local M = {}

function M.get_option(name, default)
  local handle = io.popen("tmux show-option -gqv " .. name)
  if not handle then
    return default
  end

  local result = handle:read("*a") or ""
  handle:close()
  result = result:gsub("%s+$", "")

  if result == "" then
    return default
  end
  return result
end

return M
