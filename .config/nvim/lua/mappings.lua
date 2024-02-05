local wk = require('which-key')
wk.register({
  ["<leader>"] = {
    f = {
      name = "+finders",
      n = { "<cmd>enew<cr>", "New file" },
      f = "TS search files",
      g = "TS live grep",
      o = "TS old files",
      b = "TS search buffers",
      h = "TS help tags",
      r = "RG ripgrep"
    },
    u = "undo tree toggle",
    m = "markdown preview",
    s = {
      name = "+scripts",
      c = "compiler",
      r = "compiler with stdin",
      t = "open buffer path in terminal",
    },
    -- "[" = "prev tab",
    -- "]" = "next tab",
    -- "\"" = "list buffers",
    -- "," = "prev buffer",
    -- "." = "next buffer",
  },
})
