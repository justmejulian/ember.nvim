# Ember.nvim

Tools to enhance development with Ember.js in Neovim.
You don't this plugin to use Ember.js in Neovim, but it implements some of the features that are not part of the standard LSP protocol.

Make sure you already have the [Ember Language Server](https://github.com/emberwatch/ember-language-server) installed and running in your project.

Inspired by [Ember VSCode Extension](https://github.com/ember-tooling/vscode-ember)

## Features

- Navigate between related files in your Ember.js project
    - Quickfix list or Snacks.nvim picker

## Requirements

- [Ember Language Server](https://github.com/emberwatch/ember-language-server)
- [Snacks.nvim](https://github.com/echasnovski/snacks.nvim) (optional, for enhanced picking experience)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'justmejulian/ember.nvim',
  opts = {
    picker = 'quickfix', -- 'quickfix' (default) or 'snacks.picker'
  },
}
```

## Usage

The plugin exposes both commands and functions.

- `EmberGetRelatedFiles` / `get_related_files`
    - Get related files for the current Ember.js file.
- `EmberGetKindUsages` / `get_kind_usages`
    - Get usages of the current Ember.js file

#### Commands Example Usage

```
:EmberGetRelatedFiles
```

#### Functions Example Usage

```lua
-- Add to your keymaps
vim.keymap.set('n', '<leader>er', require('ember').get_related_files, { desc = 'Ember Related Files' })

```
