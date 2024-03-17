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
  automatic_installation = true,
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

require("neodev").setup {}
lspconfig.lua_ls.setup {
  capabilities = capabilities,
  on_attach = my_attach,
  single_file_support = true,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { 'vim' },
          },
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
          },
          format = {
            enable = true,
            -- Put format options here
            -- NOTE: the value should be String!
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            }
          },
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
}
