local M = {}

--- Given a list of results, create a table of items for the picker.
--- @param results table<string> List of file paths or names
--- @return snacks.picker.finder.Item[]
local function create_snack_picker_items(results, search)
  local items = {}
  for _, result in pairs(results) do
    table.insert(items, {
      text = result,
      file = result,
      search = search,
    })
  end
  return items
end

--- Create a snacks picker
--- @param title string The title of the picker
--- @param items table<string> List of file paths or names to display in the picker
local function snacks_picker(title, items, search)
  local picker = require 'snacks.picker'
  picker.pick {
    title = title,
    items = create_snack_picker_items(items, search),
    format = 'file',
    preview = function(ctx)
      local Prevew = require 'snacks.picker.preview'
      Prevew.file(ctx)

      if search ~= nil then
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.search(search)
          vim.cmd 'normal! zz'
          vim.fn.clearmatches()
          vim.fn.matchadd('Search', search)
        end)
      end
    end,
    actions = {
      confirm = function(current_picker, item)
        current_picker:close()
        vim.cmd('edit ' .. item.file) -- Open the selected file
        if item.search ~= nil then
          vim.schedule(function()
            vim.api.nvim_feedkeys('/' .. item.search .. '\n', 'n', false)
          end)
        end
      end,
    },
  }
end

--- @param title string The title of the picker
--- @param items string[] List of file paths or names to display
--- @param search? string Pattern to search after selection
local function telescope_picker(title, items, search)
  print 'Using telescope picker'
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  pickers
    .new({}, {
      prompt_title = title,
      finder = finders.new_table {
        results = items,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry,
            ordinal = entry,
            path = entry,
          }
        end,
      },
      previewer = conf.file_previewer {},
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local file = selection.path or selection.value
          if file then
            vim.cmd('edit ' .. file)
            if search then
              vim.schedule(function()
                vim.api.nvim_feedkeys('/' .. search .. '\n', 'n', false)
              end)
            end
          end
        end)
        return true
      end,
    })
    :find()
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

---@alias picker "snacks.picker" | "quickfix" | "telescope"

--- Get the appropriate picker function based on the picker type.
--- @param picker picker The type of picker to return
function M.get_picker(picker)
  if picker == 'snacks.picker' then
    return snacks_picker
  elseif picker == 'quickfix' then
    return quickfix_picker
  elseif picker == 'telescope' then
    return telescope_picker
  else
    error('Unknown picker type: ' .. tostring(picker))
  end
end

return M
