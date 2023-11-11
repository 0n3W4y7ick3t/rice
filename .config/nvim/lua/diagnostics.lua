local signs = { Error = "x", Warn = "!", Hint = ":", Info = "?" }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  virtual_text = {
    source = "always",  -- Or "if_many"
    prefix = '●', -- Could be '●', '▎', 'x'
  },
  float = {
    source = "always",  -- Or "if_many"
  },
})
