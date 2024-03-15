vim.cmd([[
" automatically install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
" enhancement
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'stevearc/aerial.nvim'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'iamcco/markdown-preview.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-telescope/telescope.nvim'
Plug 'szw/vim-maximizer'
Plug 'mbbill/undotree'
Plug 'HiPhish/rainbow-delimiters.nvim'
Plug 'rmagatti/auto-session'
" edit
Plug 'Raimondi/delimitMate'
Plug 'smoka7/hop.nvim'
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'folke/which-key.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
" debug
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
" nvim-cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug '0n3W4y7ick3t/cmp-nvim-lsp-signature-help'
" statusline
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
" colorscheme
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'folke/tokyonight.nvim'
" for rust
Plug 'mrcjkb/rustaceanvim'
call plug#end()
]])

vim.g.mapleader = ' '
vim.g.mkdp_browser = 'firefox' -- markdown preview

-- lf
vim.g.lf_replace_netrw = 1
vim.g.lf_command_override = 'lf -command "set hidden"'
vim.g.lf_map_keys = 0
-- pairs
vim.delimitMate_expand_cr = 2
vim.delimitMate_expand_inside_quotes = 1
vim.g.floaterm_keymap_toggle = ',t'
vim.g.floaterm_position = 'bottom'
vim.g.floaterm_width = 0.99
vim.g.floaterm_height = 0.6

require('hop').setup()
require('dapui').setup()
require('Comment').setup()
require('auto-session').setup()
require('nvim-dap-virtual-text').setup()
require('telescope').load_extension('aerial')

require 'nvim-cmp-config'
require 'lsp-config'
require 'treesitter-config'
require 'diagnostics'
require 'rustaceanvim'
require 'git-signs'
require 'mappings' -- keymapping and doc
require 'dap-config'
require 'outline'

-- autocommands
-- disable annoying diagnostic for env files
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.env",
  callback = function() vim.diagnostic.disable(0) end,
})
-- automatically deletes all trailing whitespace and newlines at end of file
-- on save, reset cursor position
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[
    let currPos = getpos('.')
    %s/\s\+$//e
    %s/\n\+\%$//e
    cal cursor(currPos[1], currPos[2])
    ]])
  end,
})

-- return to last edit position when opening file again
-- CONFLICTS WITH auto-session
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   pattern = "*",
--   callback = function()
--     vim.cmd([[
--     if line(''\"') >= 1 && line(''\"') <= line('$') && &ft !~# 'commit'
--     |   exe "normal! g`\""
--     endif
--     ]])
--   end,
-- })


vim.cmd([[
syntax on
filetype on
filetype plugin on
filetype indent on

autocmd BufWritePost $MYVIMRC :so $MYVIMRC
" automatically generates shortcuts after saving bookmark files
autocmd BufWritePost $HOME/.config/shell/bm-* :silent! !shortcuts

" shortcuts for command mode
source $HOME/.config/nvim/shortcuts.vim

call wilder#setup({'modes': [':', '/', '?']})

hi TreesitterContextBottom gui=underline guisp=Grey

" Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {}
let g:vimwiki_list = [{
  \ 'auto_export': 0,
  \ 'path': "$VIMWIKI_DIR/contents",
  \ 'path_html': "$VIMWIKI_DIR/_site",
  \ 'template_path': "$VIMWIKI_DIR/templates",
  \ 'template_default': 'markdown',
  \ 'template_ext':'.html',
  \ 'syntax': 'markdown',
  \ 'ext': '.viki',
\}]

" *** others ***
set ai et ts=2 sw=2
" do not use space when indenting in .go
autocmd BufRead *.go :set noet
" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=cro
autocmd FocusLost * redraw!

set completeopt=menu,menuone,noselect
set noswapfile nobk nowb " disable swap and backup file
set autoread
set mousehide
set noshowcmd
set nu rnu " line number
set title
set wrap
set linebreak
set history=1000
set numberwidth=1
nnoremap <F2> :set invpaste paste?<cr>
set pastetoggle=<F2>
set showmode
set sb spr " split
set encoding=utf-8
set wildmode=longest,list,full
set hls ic scs is " search
set vb t_vb=
set iskeyword+=:
set shellslash
set clipboard^=unnamedplus

" :W force save with sudo
cabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" themes and statusline settings
let $THEME="tokyonight"
set background=dark

if !has('gui_running')
  set t_Co=256
endif

" enable truecolor
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    set pumblend=40
endif

colorscheme $THEME

" show current line number as bold highlighted
set cursorline
hi CursorLineNr cterm=bold gui=bold
set cursorlineopt=number
]])
require 'themes'
