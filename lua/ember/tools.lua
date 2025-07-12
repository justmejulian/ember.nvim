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
  lsp.execute_command(params, picker)
end

return M
