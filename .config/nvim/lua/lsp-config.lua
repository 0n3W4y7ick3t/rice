-- lsp-config.lua: set up lsp plugin
require('lsp-mappings')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = {
  'bashls',
  'clangd',
  'gopls',
  -- the only way I found this work is to use pip to install pylyzer,
  -- and use that SAME venv to code.
  'pylyzer',
  'marksman',
  'zls',
}

-- Update nvim-cmp capabilities and add them to each language server
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    capabilities = capabilities,
    on_attach = my_attach,
    single_file_support = true,
  }
end

require 'lspconfig'.lua_ls.setup {
  capabilities = capabilities,
  on_attach = my_attach,
  single_file_support = true,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
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
