-- docs keymap descriptions for which-key
local wk = require('which-key')
wk.register({
  ['<leader>'] = {
    a = { '<cmd>AerialToggle!<CR>', 'toggle aerial outline' },
    b = {
      name = '+ buffers',
      p = { 'pin/unpin buffer' },
      c = { 'close all unpined buffers' },
    },
    o = { '<cmd>AerialOpen float<CR>', 'toggle aerial float' },
    c = {
      name = '+ configs',
      f = { ':tabe $MYVIMRC<cr>', 'init.vim' },
      m = { ':vs $HOME/.config/nvim/lua/whichkey.lua<cr>', 'mappings' },
      n = { ':vs $HOME/.config/nvim/lua/neovim.lua<cr>', 'neovim options' },
      p = { ':vs $HOME/.config/nvim/lua/plugins.lua<cr>', 'plugins' },
      t = { ':tabe $HOME/.config/nvim/lua/themes.lua<cr>', 'themes' },
    },
    d = {
      name = '+ debug, <leader>d is not needed for <fn>',
      b = 'breakpoint with message',
      f = 'frames',
      h = 'hover',
      l = 'run last',
      o = 'repl open',
      p = 'preview',
      s = 'scopes',
      ['-'] = 'F5-F10:',
      ['<F5>'] = 'start/continue debug',
      ['<F6>'] = 'breakpoint toggle',
      ['<F7>'] = 'step over',
      ['<F8>'] = 'step into',
      ['<F9>'] = 'step out',
      ['<F10>'] = 'toggle dapui',
    },
    e = 'diagnostic float info',
    f = {
      name = '+ finders! telescope and fzf',
      -- map('n', '<leader>fr', )
      a = { ':Telescope aerial<cr>', 'TS search aerial' },
      b = { ':Telescope current_buffer_fuzzy_find<cr>', 'TS search current buffer' },
      B = { ':Telescope builtin<cr>', 'TS all builtins' },
      f = { ':Telescope find_files<cr>', 'TS search files' },
      g = { ':Telescope live_grep<cr>', 'TS live grep' },
      h = { ':Telescope help_tags<cr>', 'TS help tags' },
      l = { ':Telescope buffers<cr>', 'TS search buffer list' },
      o = { ':Telescope oldfiles<cr>', 'TS old files' },
      s = { ':Telescope grep_string<cr>', 'TS grep string' },
      t = { ':TodoTelescope<cr>', 'TS Todos' },
      r = { ':RG ', 'RG ripgrep', silent = false },
    },
    g = {
      name = '+ goto',
      C = 'go to context',
      D = 'go to declaration',
      d = 'go to definition',
      I = 'go to implementation',
      r = 'go to references',
      t = 'go to type definition',
    },
    h = {
      name = '+ hunk options',
      t = {
        name = '+ toggle',
        b = 'toggle line blame',
        d = 'toggle deleted',
      },
    },
    l = {
      name = '+ lsp options',
      a = 'lsp code actions',
      f = 'lsp format',
      r = 'lsp rename',
    },

    m = 'markdown preview',
    q = 'diagnostic telescope',
    u = { ':UndotreeToggle<cr>', 'undo tree toggle' },
    r = {
      name = '+ run',
      -- script to compile and run single source code file,
      -- with and without input redirect
      c = { ':w! \\| !nvim-compiler "%:p"<cr>', 'compiler' },
      r = { ':w! \\| !nvim-compiler-red "%:p"<cr>', 'compiler < inp' },
    },
    s = {
      name = '+ snippets',
      v = { ':VsnipOpenVsplit<cr>', 'vsnip vsplit edit' },
      y = { ':VsnipYank<cr>', 'vsnip yank' },
    },
    w = {
      name = '+ wiki, workspace',
      i = 'VimWiki diary index',
      s = 'VimWiki select',
      t = 'VimWiki table index',
      w = 'VimWiki index',
      k = {
        name = '+ workspace',
        a = 'add',
        l = 'list',
        r = 'remove',
      },
      ['<space>'] = {
        name = '+ wiki util',
        i    = 'DiaryGenerateLinks',
        m    = 'MakeTomorrowDiaryNote',
        t    = 'TabMakeDiaryNote',
        w    = 'MakeDiaryNote',
        y    = 'MakeYesterdayDiaryNote',
      }
    },
    -- --tabs and buffers
    ['['] = { ':tabp<cr>', 'prev tab' },
    [']'] = { ':tabn<cr>', 'next tab' },
    [','] = { ':bp<cr>', 'prev buffer' },
    ['.'] = { ':bn<cr>', 'next buffer' },

    [';'] = { 'A;<Esc>', 'quickly add ;' },
    ['<cr>'] = { ':MaximizerToggle<cr>', "toggle maximize" },
  },
  ['['] = {
    name = '+ prev',
    ['%'] = 'prev unmatched group',
    ['('] = 'prev (',
    ['<'] = 'prev <',
    ['{'] = 'prev {',
    [']'] = 'prev function start',
    ['<space>'] = 'add blank line up',
    A = 'first file',
    a = 'prev file',
    B = 'first buffer',
    b = 'prev buffer',
    c = 'prev hunk',
    d = 'prev diagnostic',
    e = 'move line up',
    f = 'prev FIX/BUG/ERROR',
    t = 'prev TODO/WARN/HACK',
    o = 'prev OPT/TEST',
    i = 'prev conditional',
    n = 'prev conflict',
    p = 'prev parameter',
    z = 'prev fold',
  },
  [']'] = {
    name = '+ next',
    ['%'] = 'next unmatched group',
    ['('] = 'next (',
    ['<'] = 'next <',
    ['{'] = 'next {',
    [']'] = 'next function start',
    ['<space>'] = 'add blank line down',
    A = 'last file',
    a = 'next file',
    B = 'last buffer',
    b = 'next buffer',
    c = 'next hunk',
    d = 'next diagnostic',
    e = 'move line down',
    f = 'next FIX/BUG/ERROR',
    t = 'next TODO/WARN/HACK',
    o = 'next OPT/TEST',
    i = 'next conditional',
    n = 'next conflict',
    p = 'next parameter',
    z = 'next fold',
  },
  [','] = {
    -- terminals
    name = '+ terminals',
    ['/'] = { ':nohlsearch<cr>', "disable hl search" },
    f = 'floaterm(cwd)',
    t = { ':ToggleTerm<cr>', 'toggleterm' },
    g = 'lazygit in ToggleTerm',
  },
})

-- use ToggleTerm to open lazygit
local lazygit = require('toggleterm.terminal').Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  -- function to run on closing the terminal
  on_close = function(_)
    vim.cmd("startinsert!")
  end,
})

function _lazygit_toggle()
  lazygit:toggle()
end

vim.api.nvim_set_keymap('n', ',g', '<cmd>lua _lazygit_toggle()<CR>', { noremap = true, silent = true })

local todo = require("todo-comments")
vim.keymap.set("n", "[t", function() todo.jump_prev({ keywords = { "TODO", "HACK", "WARN" } }) end)
vim.keymap.set("n", "]t", function() todo.jump_next({ keywords = { "TODO", "HACK", "WARN" } }) end)
vim.keymap.set("n", "[o", function() todo.jump_prev({ keywords = { "TEST", "OPT" } }) end)
vim.keymap.set("n", "]o", function() todo.jump_next({ keywords = { "TEST", "OPT" } }) end)
vim.keymap.set("n", "[f", function()
  todo.jump_prev({ keywords = { "FIXME", "FIXIT", "BUG", "ISSUE", "ERROR", "ERR" } })
end)
vim.keymap.set("n", "]f", function()
  todo.jump_next({ keywords = { "FIXME", "FIXIT", "BUG", "ISSUE", "ERROR", "ERR" } })
end)

local map = vim.keymap.set
local nmap = function(key, mapping) -- most of the keymap
  vim.keymap.set('n', key, mapping, { noremap = true })
end
local nomute = { noremap = true }
local mute = { noremap = true, silent = true }

-- Some basics:
nmap('c', '"_c')
map('n', 'S', ':%s//g<left><left>', nomute)
map('v', '.', ':normal .<cr>', mute)
nmap('Q', ':x<cr>')
nmap('qq', ':bd<cr>')
nmap('W', ':w<cr>')
nmap('<c-q>', ':q!<cr>') -- force quit
nmap(',,', '<c-w>w')
map('t', ',,', '<c-\\><c-n><c-w>w', mute)
-- jump between {}
nmap('<tab>', '%')
-- jump between selected boundrys in visual mode
map('v', '<tab>', 'o', mute)
-- panel navigation
map({ 'n', 'v' }, '<c-h>', '<c-w>h', mute)
map({ 'n', 'v' }, '<c-l>', '<c-w>l', mute)
map({ 'n', 'v' }, '<c-j>', '<c-w>j', mute)
map({ 'n', 'v' }, '<c-k>', '<c-w>k', mute)
