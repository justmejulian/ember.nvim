local utils = require 'ember.utils'

local M = {}

---@class lsp.command.params
---@field command string The command to execute
---@field arguments? table Optional arguments for the command

--- Execute a command on the LSP server and return the results.
---@param params? lsp.command.params Parameters for the command to execute
---@param callback fun(items: table): nil Callback function to handle the results
function M.execute_command(params, callback)
  if params == nil or utils.isEmpty(params) then
    vim.notify('No parameters provided for lsp.execute_command', vim.log.levels.WARN)
    return
  end

  vim.lsp.buf_request(0, 'workspace/executeCommand', params, function(err, results)
    if err then
      vim.notify('Error: ' .. err.message, vim.log.levels.ERROR)
      return
    end

    if results == nil or utils.isEmpty(results) then
      vim.notify('No resutls returned command: ' .. params.command, vim.log.levels.WARN)
      return
    end

    callback(results)
  end)
end

return M
