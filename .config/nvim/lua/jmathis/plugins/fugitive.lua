return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gsv', '<cmd>vert Git<CR>', { desc = 'Open Git (vert)' })
    vim.keymap.set('n', '<leader>gsh', vim.cmd.Git, { desc = 'Open Git' })
  end,
}
