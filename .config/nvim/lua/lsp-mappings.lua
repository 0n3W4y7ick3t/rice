function my_attach(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local function nmap(l, r, explain)
    local opts = { noremap = true, silent = true, desc = explain }
    vim.api.nvim_set_keymap('n', l, r, opts)
  end

  nmap('<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', 'diagnostic open float')
  nmap('<space>q', '<cmd>Telescope diagnostics<CR>', 'diagnostic telescope')
  nmap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'diagnostic prev')
  nmap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 'diagnostic next')

  ----
  local function buf_map(mode, l, r, explain)
    local opts = { noremap = true, silent = true, desc = explain }
    vim.api.nvim_buf_set_keymap(bufnr, mode, l, r, opts)
  end
  buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', 'go to declaration')
  buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', 'go to definition')
  buf_map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'go to type definition')
  buf_map('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', 'go to implementation')
  buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', 'go to references')
  vim.keymap.set('n', 'gC', function()
    require("treesitter-context").go_to_context()
  end, { silent = true, desc = 'go to treesitter-context' })
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'lsp hover')
  buf_map('n', '<c-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'show signature_help')
  buf_map('i', '<c-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'show signature_help')
  buf_map('n', '<space>wka', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'add_workspace_folder')
  buf_map('n', '<space>wkr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'remove_workspace_folder')
  buf_map('n', '<space>wkl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'print workspace')
  buf_map('n', '<space>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', 'lsp rename')
  -- buf_map('n', '<space>lf', '<cmd>lua vim.lsp.buf.format({aysnc=true})<CR>', 'lsp format')
  buf_map('n', '<space>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', 'code actions')
  buf_map('v', '<space>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', 'code actions')
end
