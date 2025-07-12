local tools = require 'ember.tools'
local utils = require 'ember.utils'

local M = {}

--- Register a command to get related files for the current file.
--- @param picker fun(title: string, items: table<string>): nil
--- @param buf number Buffer number where the command will be registered
local function register_get_related_files(picker, buf)
  vim.api.nvim_buf_create_user_command(buf, 'EmberGetRelatedFiles', function()
    tools.get_related_files(function(results)
      picker('Related Files', results)
    end)
  end, {
    desc = 'Get related files for the current file',
  })
end

--- Register a command to get usages of the current kind.
--- @param picker fun(title: string, items: table<string>): nil
--- @param buf number Buffer number where the command will be registered
local function register_get_kind_usages(picker, buf)
  vim.api.nvim_buf_create_user_command(buf, 'EmberGetKindUsages', function()
    tools.get_kind_usages(function(results)
      picker('Kind Usages', results)
    end)
  end, {
    desc = 'Get usages of the current kind',
  })
end

--- Register commands for the Ember module.
--- @param picker fun(title: string, items: table<string>): nil
function M.register_commands(picker)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'typescript', 'handlebars' },
    callback = function(args)
      register_get_related_files(picker, args.buf)
      register_get_kind_usages(picker, args.buf)
    end,
  })
end

return M
