return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '' },
      change = { text = '' },
      delete = { text = '' },
      topdelete = { text = '‾' },
      changedelete = { text = '' },
    },
    signs_staged = {
      add = { text = '' },
      change = { text = '' },
      delete = { text = '' },
      topdelete = { text = '‾' },
      changedelete = { text = '' },
    },
    signs_staged_enable = true,
    auto_attach = true,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol',
      delay = 500,
      ignore_whitespace = false,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  },
}
