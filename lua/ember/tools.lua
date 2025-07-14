local utils = require 'ember.utils'
local lsp = require 'ember.lsp'

local M = {}

--- Get related files for the current file using LSP and open a picker with the results.
---@param picker fun(items: table<string>): nil Function to open a picker with the results
function M.get_related_files(picker)
  local file_path = utils.get_absolute_path()

  local params = {
    command = 'els.getRelatedFiles',
    arguments = {
      file_path,
      { includeMeta = false },
    },
  }

  -- Execute lsp command and pass the results to the picker
  lsp.execute_command(params, function(results)
    local file_names = {}
    for _, file in ipairs(results) do
      if file and file ~= '' then
        table.insert(file_names, file)
      end
    end

    picker(results)
  end)
end

--- Get usages of the current kind using LSP and open a picker with the results.
--- @param picker fun(items: table<string>): nil Function to open a picker with the results
function M.get_kind_usages(picker)
  local file_path = utils.get_absolute_path()

  local params = {
    command = 'els.getKindUsages',
    arguments = {
      file_path,
      { includeMeta = false },
    },
  }

  --- Execute lsp command and pass the results to the picker
  lsp.execute_command(params, function(results)
    if results.usages == nil or utils.isEmpty(results.usages) then
      vim.notify('No usages found for the current kind', vim.log.levels.WARN)
      return
    end

    local usages = {}

    for _, usage in ipairs(results.usages) do
      if usage then
        table.insert(usages, usage.path)
      end
    end

    picker(usages)
  end)
end

return M
