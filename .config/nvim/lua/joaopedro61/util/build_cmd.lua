---@return string?
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

