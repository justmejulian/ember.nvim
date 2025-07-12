local ember = require 'ember.tools'

local M = {}

--- Register a command to get related files for the current file.
--- @param picker function(title: string, items: table<string>): void
--- @param buf number Buffer number where the command will be registered
local function register_get_related_files(picker, buf)
  vim.api.nvim_buf_create_user_command(buf, 'EmberGetRelatedFiles', function()
    ember.get_related_files(function(results)
      picker('Related Files', results)
    end)
  end, {
    desc = 'Get related files for the current file',
  })
end

--- Register commands for the Ember module.
--- @param picker function(title: string, items: table<string>): void
function M.register_commands(picker)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'typescript', 'handlebars' },
    callback = function(args)
      register_get_related_files(picker, args.buf)
    end,
  })
end

return M
