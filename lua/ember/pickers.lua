local M = {}

--- Given a list of results, create a table of items for the picker.
--- @param results table<string> List of file paths or names
--- @return snacks.picker.finder.Item[]
local function create_snack_picker_items(results)
  local items = {}
  for _, result in pairs(results) do
    table.insert(items, {
      text = result,
      file = result,
    })
  end
  return items
end

--- Create a snacks picker
--- @param title string The title of the picker
--- @param items table<string> List of file paths or names to display in the picker
local function snacks_picker(title, items)
  local picker = require 'snacks.picker'
  picker.pick {
    title = title,
    items = create_snack_picker_items(items),
    format = 'file',
    actions = {
      confirm = function(current_picker, item)
        current_picker:close()
        vim.cmd('edit ' .. item.file) -- Open the selected file
      end,
    },
  }
end

--- Given a list of results, create a table of items for the quickfix list.
--- @param results table<string> List of file paths or names
--- @return snacks.picker.finder.Item[]
local function create_qf_items(results)
  local items = {}
  for _, result in pairs(results) do
    table.insert(items, {
      text = result,
      filename = result,
    })
  end
  return items
end

--- Create a quickfix picker
--- @param title string The title of the quickfix list
--- @param items table<string> List of file paths or names to display in the quickfix list
local function quickfix_picker(title, items)
  vim.fn.setqflist(
    {}, -- Ignored when using `action = " "`
    ' ', -- Action to replace the current quickfix list
    {
      title = title,
      items = create_qf_items(items),
    }
  )
  vim.cmd 'copen'
end

---@alias picker "snacks.picker" | "quickfix"

--- Get the appropriate picker function based on the picker type.
--- @param picker picker The type of picker to return
function M.get_picker(picker)
  if picker == 'snacks.picker' then
    return snacks_picker
  elseif picker == 'quickfix' then
    return quickfix_picker
  else
    error('Unknown picker type: ' .. tostring(picker))
  end
end

return M
