-- docs keymap descriptions for which-key
local wk = require('which-key')
wk.add({
  {
    { ",",  group = " terminals" },
    { ",/", ":nohlsearch<cr>",             desc = "disable hl search" },
    { ",f", desc = "floaterm(cwd)" },
    { ",g", desc = "lazygit in ToggleTerm" },
  },
  { "<leader>,",    ":bp<cr>",                desc = "prev buffer" },
  { "<leader>.",    ":bn<cr>",                desc = "next buffer" },
  { "<leader>;",    "A;<Esc>",                desc = "quickly add ;" },
  { "<leader><cr>", ":MaximizerToggle<cr>",   desc = "toggle maximize" },
  { "<leader>[",    ":tabp<cr>",              desc = "prev tab" },
  { "<leader>]",    ":tabn<cr>",              desc = "next tab" },
  { "<leader>a",    "<cmd>AerialToggle!<CR>", desc = "toggle aerial outline" },
  {
    { "<leader>b",  group = " buffers" },
    { "<leader>bc", desc = "close all unpined buffers" },
    { "<leader>bp", desc = "pin/unpin buffer" },
  },
  {
    { "<leader>c",  group = " configs" },
    { "<leader>cf", ":tabe $MYVIMRC<cr>",                          desc = "init.vim" },
    { "<leader>cm", ":vs $HOME/.config/nvim/lua/whichkey.lua<cr>", desc = "mappings" },
    { "<leader>cn", ":vs $HOME/.config/nvim/lua/neovim.lua<cr>",   desc = "neovim options" },
    { "<leader>cp", ":vs $HOME/.config/nvim/lua/plugins.lua<cr>",  desc = "plugins" },
    { "<leader>ct", ":tabe $HOME/.config/nvim/lua/themes.lua<cr>", desc = "themes" },
  },
  {
    { "<leader>d",      group = " debug" },
    { "<leader>d-",     desc = "F4-F10, <leader>d is not needed:" },
    { "<leader>d<F10>", desc = "toggle dapui" },
    { "<leader>d<F4>",  desc = "run to cursor" },
    { "<leader>d<F5>",  desc = "start/continue debug" },
    { "<leader>d<F6>",  desc = "breakpoint toggle" },
    { "<leader>d<F7>",  desc = "step over" },
    { "<leader>d<F8>",  desc = "step into" },
    { "<leader>d<F9>",  desc = "step out" },
    { "<leader>db",     desc = "breakpoint with message" },
    { "<leader>df",     desc = "show frames" },
    { "<leader>dl",     desc = "run last" },
    { "<leader>dp",     desc = "preview" },
    { "<leader>dq",     desc = "quit debug" },
    { "<leader>dr",     desc = "repl toggle" },
    { "<leader>ds",     desc = "show scopes" },
  },

  { "<leader>e", desc = "diagnostic float info" },
  {
    { "<leader>f",  group = " finders! telescope and fzf" },
    { "<leader>fB", ":Telescope builtin<cr>",                   desc = "TS all builtins" },
    { "<leader>fa", ":Telescope aerial<cr>",                    desc = "TS search aerial" },
    { "<leader>fb", ":Telescope current_buffer_fuzzy_find<cr>", desc = "TS search current buffer" },
    { "<leader>ff", ":Telescope find_files<cr>",                desc = "TS search files" },
    { "<leader>fg", ":Telescope live_grep<cr>",                 desc = "TS live grep" },
    { "<leader>fh", ":Telescope help_tags<cr>",                 desc = "TS help tags" },
    { "<leader>fl", ":Telescope buffers<cr>",                   desc = "TS search buffer list" },
    { "<leader>fo", ":Telescope oldfiles<cr>",                  desc = "TS old files" },
    { "<leader>fR", ":RG ",                                     desc = "RG ripgrep",              silent = false },
    { "<leader>fr", ":Telescope builtin resume",                desc = "TS resume last list" },
    { "<leader>fs", ":Telescope grep_string<cr>",               desc = "TS grep string" },
    { "<leader>ft", ":TodoTelescope<cr>",                       desc = "TS Todos" },
  },
  {
    { "<leader>g",  group = " goto" },
    { "<leader>gC", desc = "go to context" },
    { "<leader>gg", desc = "go to github/gitlab" },
    { "<leader>gD", desc = "go to declaration" },
    { "<leader>gI", desc = "go to implementation" },
    { "<leader>gd", desc = "go to definition" },
    { "<leader>gr", desc = "go to references" },
    { "<leader>gt", desc = "go to type definition" },
  },
  {
    { "<leader>h",   group = " hunk options" },
    { "<leader>ht",  group = " toggle" },
    { "<leader>htb", desc = "toggle line blame" },
    { "<leader>htd", desc = "toggle deleted" },
  },
  {
    { "<leader>l",  group = " lsp options" },
    { "<leader>la", desc = "lsp code actions" },
    { "<leader>lf", desc = "lsp format" },
    { "<leader>lr", desc = "lsp rename" },

  },
  { "<leader>o", "<cmd>AerialOpen float<CR>",   desc = "toggle aerial float" },
  { "<leader>q", desc = "diagnostic telescope" },
  {
    { "<leader>r",  group = " run" },
    { "<leader>rc", ':w! | !nvim-compiler "%:p"<cr>',     desc = "compiler" },
    { "<leader>rr", ':w! | !nvim-compiler-red "%:p"<cr>', desc = "compiler < inp" },
  },
  {
    { "<leader>s",  group = " snippets" },
    { "<leader>sv", ":VsnipOpenVsplit<cr>", desc = "vsnip vsplit edit" },
    { "<leader>sy", ":VsnipYank<cr>",       desc = "vsnip yank" },
  },
  { "<leader>u", ":UndotreeToggle<cr>", desc = "undo tree toggle" },
  {
    { "<leader>w",         group = " wiki, workspace" },
    { "<leader>w<space>",  group = " wiki util" },
    { "<leader>w<space>i", desc = "DiaryGenerateLinks" },
    { "<leader>w<space>m", desc = "MakeTomorrowDiaryNote" },
    { "<leader>w<space>t", desc = "TabMakeDiaryNote" },
    { "<leader>w<space>w", desc = "MakeDiaryNote" },
    { "<leader>w<space>y", desc = "MakeYesterdayDiaryNote" },
    { "<leader>wi",        desc = "VimWiki diary index" },
    { "<leader>wk",        group = " workspace" },
    { "<leader>wka",       desc = "add" },
    { "<leader>wkl",       desc = "list" },
    { "<leader>wkr",       desc = "remove" },
    { "<leader>ws",        desc = "VimWiki select" },
    { "<leader>wt",        desc = "VimWiki table index" },
    { "<leader>ww",        desc = "VimWiki index" },
  },
  {
    { "[",        group = " prev" },
    { "[%",       desc = "prev unmatched group" },
    { "[(",       desc = "prev (" },
    { "[<",       desc = "prev <" },
    { "[<space>", desc = "add blank line up" },
    { "[A",       desc = "first file" },
    { "[B",       desc = "first buffer" },
    { "[]",       desc = "prev function start" },
    { "[a",       desc = "prev file" },
    { "[b",       desc = "prev buffer" },
    { "[c",       desc = "prev hunk" },
    { "[d",       desc = "prev diagnostic" },
    { "[e",       desc = "move line up" },
    { "[f",       desc = "prev FIX/BUG/ERROR" },
    { "[i",       desc = "prev conditional" },
    { "[n",       desc = "prev conflict" },
    { "[o",       desc = "prev OPT/TEST" },
    { "[p",       desc = "prev parameter" },
    { "[t",       desc = "prev TODO/WARN/HACK" },
    { "[z",       desc = "prev fold" },
    { "[{",       desc = "prev {" },
  },
  {
    { "]",        group = " next" },
    { "]%",       desc = "next unmatched group" },
    { "](",       desc = "next (" },
    { "]<",       desc = "next <" },
    { "]<space>", desc = "add blank line down" },
    { "]A",       desc = "last file" },
    { "]B",       desc = "last buffer" },
    { "]]",       desc = "next function start" },
    { "]a",       desc = "next file" },
    { "]b",       desc = "next buffer" },
    { "]c",       desc = "next hunk" },
    { "]d",       desc = "next diagnostic" },
    { "]e",       desc = "move line down" },
    { "]f",       desc = "next FIX/BUG/ERROR" },
    { "]i",       desc = "next conditional" },
    { "]n",       desc = "next conflict" },
    { "]o",       desc = "next OPT/TEST" },
    { "]p",       desc = "next parameter" },
    { "]t",       desc = "next TODO/WARN/HACK" },
    { "]z",       desc = "next fold" },
    { "]{",       desc = "next {" },
  },
})

-- Terminal and buffer navigation with tmux awareness
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  vim.keymap.set('t', '<C-h>', [[<C-\><C-n>:<C-u>TmuxNavigateLeft<cr>]], opts)
  vim.keymap.set('t', '<C-j>', [[<C-\><C-n>:<C-u>TmuxNavigateDown<cr>]], opts)
  vim.keymap.set('t', '<C-k>', [[<C-\><C-n>:<C-u>TmuxNavigateUp<cr>]], opts)
  vim.keymap.set('t', '<C-l>', [[<C-\><C-n>:<C-u>TmuxNavigateRight<cr>]], opts)
end
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

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
nmap('<leader>gg', ':!git visit<cr>')
-- jump between {}
nmap('<tab>', '%')
-- jump between selected boundrys in visual mode
map('v', '<tab>', 'o', mute)
