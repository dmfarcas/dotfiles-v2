local keymap = vim.keymap.set

-- Leader key
vim.g.mapleader = ' '

-- Navigation
keymap('n', '<leader>e', vim.cmd.Ex, { desc = 'File explorer' })

-- LSP
keymap('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
keymap('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
keymap('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
keymap('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
keymap('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })

-- Telescope
keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find buffers' })
