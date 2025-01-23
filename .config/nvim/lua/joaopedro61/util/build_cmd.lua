--- Returns the first available build command found in the system.
--- It checks if the commands `make`, `cmake`, or `gmake` are executable in the system.
--- The first executable command found will be returned.
--- If none of the commands are available, it returns `nil`.
--- @return string?: The name of the first available build command (`make`, `cmake`, or `gmake`), or `nil` if none are found.
local get_build_cmd = function()
  local build_cmd ---@type string?
  for _, cmd in ipairs({ "make", "cmake", "gmake" }) do
    if vim.fn.executable(cmd) == 1 then
      build_cmd = cmd
      break
    end
  end

  return build_cmd
end

return get_build_cmd

