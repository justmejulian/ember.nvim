local M = {}

function M.get_absolute_path()
  return vim.fn.expand '%:p'
end

function M.get_relative_path()
  return vim.fn.expand '%:.'
end

function M.to_pascal_case(str)
  return str:gsub('(%a[%w%-]*)', function(segment)
    return segment
      :gsub('-(%a)', function(letter)
        return letter:upper() -- Capitalize the letter after hyphen
      end)
      :gsub('^%l', string.upper) -- Capitalize the first letter
  end)
end

function M.isEmpty(dict)
  return next(dict) == nil
end

return M
