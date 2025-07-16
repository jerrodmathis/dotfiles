vim.opt.guicursor = ''

-- Make line numbers default and disable relative line
-- numbers (for now)
vim.opt.nu = true
vim.opt.relativenumber = false

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Set default tab width
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.breakindent = true

-- Save undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Set how Neovim will display certain whitespace characters in the editor
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

-- Minimum number of screen lines to keep above and below the cursor
vim.scrolloff = 10

vim.opt.colorcolumn = '80'

vim.opt.confirm = true
