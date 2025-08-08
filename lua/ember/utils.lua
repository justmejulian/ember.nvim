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

function M.get_component_name(relative_file_path)
  local path_without_ext = relative_file_path:gsub('%.hbs$', '')
  if not path_without_ext:match '^app/components/' then
    return nil
  end

  -- Remove "app/components/"
  local cleaned_path = path_without_ext:gsub('^app/components/', '')
  local formatted = cleaned_path
    :gsub('/', '::') -- Replace `/` with `::`
    :gsub('(%a[%w%-]*)', M.to_pascal_case) -- Convert each segment to PascalCase
  formatted = '<' .. formatted
  return formatted
end

function M.isEmpty(dict)
  return next(dict) == nil
end

return M
