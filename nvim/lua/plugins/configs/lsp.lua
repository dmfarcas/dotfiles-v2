-- LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- TypeScript LSP (using typescript-tools plugin)
require('typescript-tools').setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- TypeScript-tools specific settings
    client.server_capabilities.documentFormattingProvider = true
  end,
  settings = {
    -- TypeScript-tools specific settings
    complete_function_calls = true,
    tsserver_max_memory = 4096,
  }
})

-- LSP keymaps
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client.name == 'typescript-tools' or client.name == 'tsserver' then
      -- TypeScript specific keymaps
      vim.keymap.set('n', '<leader>oi', '<cmd>TSToolsOrganizeImports<cr>', 
        { buffer = bufnr, desc = 'Organize imports' })
      vim.keymap.set('n', '<leader>ru', '<cmd>TSToolsRemoveUnused<cr>', 
        { buffer = bufnr, desc = 'Remove unused' })
      vim.keymap.set('n', '<leader>fa', '<cmd>TSToolsFixAll<cr>', 
        { buffer = bufnr, desc = 'Fix all' })
    end
  end
})
