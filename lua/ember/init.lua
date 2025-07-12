local commands = require 'ember.commands'
local pickers = require 'ember.pickers'
local tools = require 'ember.tools'

local M = {}

---@class opts
---@field picker? picker Which picker to use, defaults to "quickfix"

-- Setup function for the module
---@param opts opts
function M.setup(opts)
  local picker_type = opts.picker or 'quickfix'
  local picker = pickers.get_picker(picker_type)
  commands.register_commands(picker)

  M.get_related_files = function()
    tools.get_related_files(picker)
    tools.get_kind_usages(picker)
  end
end

return M
