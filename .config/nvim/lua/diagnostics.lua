vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "x",
      [vim.diagnostic.severity.WARN]  = "!",
      [vim.diagnostic.severity.HINT]  = ":",
      [vim.diagnostic.severity.INFO]  = "?",
    },
  },
  virtual_text = {
    source = "always",
    prefix = "●",
  },
  float = { source = "always" },
  update_in_insert = true,
})