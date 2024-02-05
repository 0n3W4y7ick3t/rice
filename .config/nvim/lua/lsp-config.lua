-- lsp-config.lua: set up lsp plugin

require('lsp-mappings')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {
  'gopls',
  'clangd',
  'pylyzer',
}

-- Update nvim-cmp capabilities and add them to each language server
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    capabilities = capabilities,
    on_attach = my_attach,
  }
end
