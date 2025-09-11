return {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup {
      filters = {
        dotfiles = false,
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      },
      renderer = {
        highlight_git = 'all',
        highlight_modified = 'all',
      },
      view = {
        width = {
          min = 20,
          max = 50,
        },
      },
    }
    local api = require 'nvim-tree.api'

    vim.api.nvim_create_autocmd('BufEnter', {
      nested = true,
      callback = function()
        if vim.fn.bufname() == 'NvimTree_1' then
          return
        end
        api.tree.find_file { buf = vim.fn.bufnr() }
      end,
    })

    local function NvimToggle()
      require('nvim-tree.api').tree.toggle {
        current_window = false,
      }
    end

    vim.keymap.set('n', '<leader>tt', NvimToggle, {
      desc = '[T]oggle NvimTree',
    })
  end,
}
