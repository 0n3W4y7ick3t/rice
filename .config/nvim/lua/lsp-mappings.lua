function my_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local function map(mode, l, r, explain)
    local opts = { noremap = true, silent = true, desc = explain }
    vim.api.nvim_set_keymap(mode, l, r, opts)
  end

  map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', 'diagnostic open float')
  map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', 'diagnostic setloclist')
  map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'diagnostic prev')
  map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 'diagnostic next')

  ----
  local function buf_map(mode, l, r, explain)
    local opts = { noremap = true, silent = true, desc = explain }
    vim.api.nvim_buf_set_keymap(bufnr, mode, l, r, opts)
  end

  buf_map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', 'go to declaration')
  buf_map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', 'go to definition')
  buf_map('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'type_definition')
  buf_map('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', 'go to implementation')
  buf_map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', 'goto references')
  buf_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'lsp hover')
  buf_map('n', '<c-K>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'show signature_help')
  buf_map('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'add_workspace_folder')
  buf_map('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'remove_workspace_folder')
  buf_map('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', 'print workspace')
  buf_map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', 'lsp rename')
  buf_map('n', '<space>fm', '<cmd>lua vim.lsp.buf.formatting({aysnc=true})<CR>', 'lsp format')
  buf_map({ 'n', 'v' }, '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', 'code actions')
end
