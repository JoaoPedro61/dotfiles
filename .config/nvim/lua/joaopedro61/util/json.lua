local M = {}

--- Reads JSON data from a file and decodes it into a Lua table.
--- 
--- @param path string: - The path to the file to read from.
--- @return (table|nil) - Returns a Lua table representing the JSON data on success, or nil if reading or decoding fails.
function M.read(path)
  local f = io.open(path, "r")
  if f then
    local data = f:read("*a")
    f:close()
    local ok, json = pcall(vim.json.decode, data, { luanil = { object = true, array = true } })
    if ok and json then
      return json
    end
  end
  return nil
end

--- Encodes a Lua table to JSON and writes it to a file.
--- 
--- @param path string: - The path to the file where data should be written.
--- @param data table: - The Lua table to encode as JSON and write to the file.
--- @return boolean: `true` if write is sucessfully and `false` is occours errors
function M.write(path, data)
  local f = io.open(path, "w")
  if f then
    f:write(vim.json.encode(data))
    f:close()
    return true
  end
  return false
end

return M;
