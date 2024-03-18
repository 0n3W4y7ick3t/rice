-- lsp-config.lua: set up lsp plugin
require 'lsp-mappings' -- import my_attach function
local cap = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').default_capabilities(cap)
local servers = {
  'bashls',
  'clangd',
  'cmake',
  'dockerls',
  'gopls',
  'golangci_lint_ls',
  'lua_ls',
  'ruff_lsp',
  'pyright',
  'marksman',
  'rust_analyzer',
  'zls',
}

require('mason').setup()
local mason_lspconfig = require 'mason-lspconfig'
mason_lspconfig.setup {
  ensure_installed = {},
  -- I manage these with the system
  automatic_installation = { exclude = { 'clangd', 'gopls', 'rust_analyzer', 'zls' } }
}

-- Update nvim-cmp capabilities and add them to each language server
local lspconfig = require('lspconfig')
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
    on_attach = my_attach,
    single_file_support = true,
  }
end
