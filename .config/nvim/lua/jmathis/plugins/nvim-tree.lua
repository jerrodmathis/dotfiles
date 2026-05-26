return {
  'nvim-tree/nvim-tree.lua',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local fsd_layer_order = {
      app = 1,
      pages = 2,
      widgets = 3,
      features = 4,
      entities = 5,
      shared = 6,
    }

    ---@param nodes { absolute_path: string, name: string, type: string }[]
    local function fsd_sorter(nodes)
      local sample = nodes[1]
      local parent_dir = sample and vim.fs.basename(vim.fs.dirname(sample.absolute_path)) or nil
      local is_src_children = parent_dir == 'src'

      table.sort(nodes, function(a, b)
        local a_is_dir = a.type == 'directory'
        local b_is_dir = b.type == 'directory'

        if a_is_dir ~= b_is_dir then
          return a_is_dir
        end

        if is_src_children and a_is_dir and b_is_dir then
          local a_rank = fsd_layer_order[a.name] or math.huge
          local b_rank = fsd_layer_order[b.name] or math.huge

          if a_rank ~= b_rank then
            return a_rank < b_rank
          end
        end

        return a.name:lower() < b.name:lower()
      end)
    end

    require('nvim-tree').setup {
      sort = {
        sorter = fsd_sorter,
      },
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
