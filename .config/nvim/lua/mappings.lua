local wk = require('which-key')
wk.register({
  ["<leader>"] = {
    f = {
      name = "+finders",
      n = { "<cmd>enew<cr>", "New file" },
      a = "TS search aerial",
      f = "TS search files",
      g = "TS live grep",
      o = "TS old files",
      b = "TS search buffers",
      h = "TS help tags",
      r = "RG ripgrep",
      m = "lsp format",
    },
    d = {
      name = "+debug",
      l = "tbd",
    },
    u = "undo tree toggle",
    m = "markdown preview",
    s = {
      name = "+scripts,snippets",
      c = "compiler",
      r = "compiler with stdin",
      v = "vsnip vsplit edit",
      y = "vsnip yank",
    },
    w = {
      name = "+wiki, workspace",
      i = "VimWiki diary index",
      t = "VimWiki table index",
      w = "VimWiki index",
      s = "VimWiki select",
      a = "add workspace",
      l = "list workspace",
      r = "remove workspace",
      ["<space>"] = {
        name = "+wiki util",
        i    = "DiaryGenerateLinks",
        y    = "MakeYesterdayDiaryNote",
        m    = "MakeTomorrowDiaryNote",
        t    = "TabMakeDiaryNote",
        w    = "MakeDiaryNote",
      }
    },
    ["["] = "prev tab",
    ["]"] = "next tab",
    [";"] = "quick add ;",
    [","] = "prev buffer",
    ["."] = "next buffer",
  },
  [","] = {
    name = "+terminals",
    s = "Floaterm send",
    t = "Floaterm toggle",
    n = "new terminal window",
  },

})
