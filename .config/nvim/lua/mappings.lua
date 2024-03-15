-- docs keymap descriptions for which-key
local wk = require('which-key')
wk.register({
  ["<leader>"] = {
    c = {
      name = "+configs",
      f = "init.vim",
      m = "mapping descriptions",
      t = "themes",
    },
    d = {
      name = "+debug",
      b = "breakpoint with message",
      d = "continue",
      f = "frames",
      h = "hover",
      l = "run last",
      o = "repl open",
      p = "preview",
      u = "ui",
      s = "scopes",
      ["-"] = "F6-F9:",
      ["<F6>"] = "breakpoint toggle",
      ["<F7>"] = "step over",
      ["<F8>"] = "step into",
      ["<F9>"] = "step out",
    },
    e = "diagnostic float info",
    f = {
      name = "+finders",
      a = "TS search aerial",
      b = "TS search buffers",
      f = "TS search files",
      g = "TS live grep",
      h = "TS help tags",
      o = "TS old files",
      r = "RG ripgrep",
    },
    g = {
      name = "+goto",
      C = "go to context",
      D = "go to declaration",
      d = "go to definition",
      I = "go to implementation",
      r = "go to references",
      t = "go to type definition",
    },
    h = {
      name = "+hunk options",
      t = {
        name = "+toggle",
        b = "toggle line blame",
        d = "toggle deleted",
      },
    },
    l = {
      name = "+lsp options",
      a = "lsp code actions",
      f = "lsp format",
      r = "lsp rename",
    },
    m = "markdown preview",
    q = "diagnostic telescope",
    u = "undo tree toggle",
    r = {
      name = "+run",
      c = "compiler",
      r = "compiler < inp",
    },
    s = {
      name = "+scripts,snippets",
      v = "vsnip vsplit edit",
      y = "vsnip yank",
    },
    w = {
      name = "+wiki, workspace",
      i = "VimWiki diary index",
      s = "VimWiki select",
      t = "VimWiki table index",
      w = "VimWiki index",
      k = {
        name = "+workspace",
        a = "add",
        l = "list",
        r = "remove",
      },
      ["<space>"] = {
        name = "+wiki util",
        i    = "DiaryGenerateLinks",
        m    = "MakeTomorrowDiaryNote",
        t    = "TabMakeDiaryNote",
        w    = "MakeDiaryNote",
        y    = "MakeYesterdayDiaryNote",
      }
    },
    ["["] = "prev tab",
    ["]"] = "next tab",
    [";"] = "quick add ;",
    [","] = "prev buffer",
    ["."] = "next buffer",
  },
  ["["] = {
    name = "+prev",
    ["%"] = "prev unmatched group",
    ["("] = "prev (",
    ["<"] = "prev <",
    ["{"] = "prev {",
    ["]"] = "prev function start",
    ["<space>"] = "add blank line up",
    A = "first file",
    a = "prev file",
    B = "first buffer",
    b = "prev buffer",
    c = "prev hunk",
    d = "prev diagnostic",
    e = "move line up",
    i = "prev conditional",
    n = "prev conflict",
    p = "prev parameter",
    z = "prev fold",
  },
  ["]"] = {
    name = "+next",
    ["%"] = "next unmatched group",
    ["("] = "next (",
    ["<"] = "next <",
    ["{"] = "next {",
    ["]"] = "next function start",
    ["<space>"] = "add blank line down",
    A = "last file",
    a = "next file",
    B = "last buffer",
    b = "next buffer",
    c = "next hunk",
    d = "next diagnostic",
    e = "move line down",
    i = "next conditional",
    n = "next conflict",
    p = "next parameter",
    z = "next fold",
  },
  [","] = {
    name = "+terminals",
    [","] = "focus back",
    n = "new terminal in current buffer directory",
    s = "floaterm send",
    t = "floaterm toggle",
  },
})

local map = vim.keymap.set
local nmap = function(key, mapping) -- most of the keymap
  vim.keymap.set('n', key, mapping, { noremap = true })
end
local nomute = { noremap = true }
local mute = { noremap = true, silent = true }

nmap('<leader>cf', ':tabe $MYVIMRC<cr>')
nmap('<leader>cm', ':vs $HOME/.config/nvim/lua/mappings.lua<cr>')
nmap('<leader>ct', ':tabe $HOME/.config/nvim/lua/themes.lua<cr>')
nmap('<a-f>', ':Lf<cr>')
-- *** plugin settings ***
nmap('<leader>m', '<Plug>MarkdownPreviewToggle')
nmap('<leader><cr>', ':MaximizerToggle<cr>')
nmap('<leader>u', ':UndotreeToggle<cr>')
nmap('HH', ':HopWord<cr>')
map('i', 'HH', '<ESC>:HopWord<cr>', mute)
-- finders! telescope and fzf
nmap('<leader>ff', '<cmd>Telescope find_files<cr>')
nmap('<leader>fg', '<cmd>Telescope live_grep<cr>')
nmap('<leader>fo', '<cmd>Telescope oldfiles<cr>')
nmap('<leader>fb', '<cmd>Telescope buffers<cr>')
nmap('<leader>fh', '<cmd>Telescope help_tags<cr>')
nmap('<leader>fa', '<cmd>Telescope aerial<cr>')
map('n', '<leader>fr', ':RG ', nomute)
-- terminals
nmap(',n', ':sp term://%:p:h//zsh<cr>i')
nmap(',,', '<c-w>w')
map('t', ',,', '<c-\\><c-n><c-w>w', mute)
map('v', ',s', ':FloatermSend<cr>', mute)
-- Some basics:
nmap('c', '"_c')
map('n', 'S', ':%s//g<left><left>', nomute)
map('v', '.', ':normal .<cr>', mute)
nmap('Q', ':bd<cr>')
nmap('W', ':w<cr>')
nmap('<leader>;', 'A;<Esc>')
nmap(',/', ':nohlsearch<cr>')
-- jump between {}
nmap('<tab>', '%')
-- jump between selected boundrys in visual mode
map('v', '<tab>', 'o', mute)
-- panel navigation
map({ 'n', 'v' }, '<c-h>', '<c-w>h', mute)
map({ 'n', 'v' }, '<c-l>', '<c-w>l', mute)
map({ 'n', 'v' }, '<c-j>', '<c-w>j', mute)
map({ 'n', 'v' }, '<c-k>', '<c-w>k', mute)
--tabs and buffers
nmap('<leader>[', '<ESC>:tabp<cr>') -- previous tab
nmap('<leader>]', '<ESC>:tabn<cr>') -- next tab
nmap('<leader>,', ':bp<cr>')        -- previous buffer
nmap('<leader>.', ':bn<cr>')        -- next buffer
nmap('<c-q>', ':q!<cr>')            -- force quit
-- script to compile and run single source code file,
-- with and without input redirect
map({ 'n', 'v' }, '<leader>rc', ':w! \\| !nvim-compiler "%:p"<cr>', mute)
map({ 'n', 'v' }, '<leader>rr', ':w! \\| !nvim-compiler-red "%:p"<cr>', mute)
map({ 'n', 'v' }, '<leader>sv', ':VsnipOpenVsplit<cr>', mute)
map({ 'n', 'v' }, '<leader>sy', ':VsnipYank<cr>', mute)
