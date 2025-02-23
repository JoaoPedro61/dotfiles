local buffer_dir = function()
  return vim.fn.expand("%:p:h")
end

return buffer_dir
