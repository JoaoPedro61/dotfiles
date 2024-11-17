local has = function(x)
  return vim.fn.has(x) == 1
end

return has
