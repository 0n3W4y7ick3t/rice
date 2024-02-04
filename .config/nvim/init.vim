syntax on
filetype on
filetype plugin on
filetype indent on
let mapleader = "\<Space>"

command CFG :tabe $MYVIMRC
command THEME :tabe $HOME/.config/nvim/themes.vim
autocmd BufWritePost $MYVIMRC :so $MYVIMRC

" automatically install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
" enhancement
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'iamcco/markdown-preview.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
Plug 'nvim-telescope/telescope.nvim',
Plug 'szw/vim-maximizer'
Plug 'mbbill/undotree'
" edit
Plug 'Raimondi/delimitMate'
Plug 'smoka7/hop.nvim'
Plug 'gelguy/wilder.nvim'
Plug 'folke/which-key.nvim'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
" debug
" Plug 'puremourning/vimspector'
" nvim-cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
" statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" colorscheme
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'folke/tokyonight.nvim'
Plug 'dylanaraps/wal.vim'
" for rust 
Plug 'mrcjkb/rustaceanvim'
call plug#end()

" themes and statusline settings
source ~/.config/nvim/themes.vim
" <leader>b to remove vim backgroud color, make it transparent
" use ]ob to refresh (dark), supported by pope/vim-unimpaired
noremap <silent> <leader>b :call SetHi()<CR>
" shortcuts for command mode
source ~/.config/nvim/shortcuts.vim

" *** plugin settings ***
" lua plugins are configured in the bottom
nnoremap <leader>m <Plug>MarkdownPreviewToggle
noremap <silent> <leader><CR> :MaximizerToggle<CR>
noremap <silent> <leader>u :UndotreeToggle<CR>
noremap <silent> H :HopWord<CR>
inoremap <silent> HH <ESC>:HopWord<CR>
call wilder#setup({'modes': [':', '/', '?']})

" let g:vimspector_enable_mappings = 'HUMAN'
hi TreesitterContextBottom gui=underline guisp=Grey

" Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
map <c-w><c-i> :VimwikiIndex<CR>
map <c-w><c-d> :VimwikiDiaryIndex<CR>
map <c-w><c-t> :VimwikiMakeDiaryNote<CR>
map <c-w><c-y> :VimwikiMakeYesterdayDiaryNote<CR>
map <c-w><c-g> :VimwikiDiaryGenerateLinks<CR>

let g:lf_replace_netrw = 1
let g:lf_command_override = 'lf -command "set hidden"'
let g:lf_map_keys = 0
noremap <silent> <a-f> :Lf<CR>

" finders! telescope and fzf
nnoremap <leader>tf <cmd>Telescope find_files<cr>
nnoremap <leader>tg <cmd>Telescope live_grep<cr>
nnoremap <leader>tb <cmd>Telescope buffers<cr>
nnoremap <leader>th <cmd>Telescope help_tags<cr>
nnoremap <leader>fg :RG 
" floaterm
noremap <leader>fs :FloatermSend<CR>
let g:floaterm_keymap_toggle = '<leader>ft'
let g:floaterm_position = 'bottom'
let g:floaterm_width = 1.0
let g:floaterm_height = 0.5
let delimitMate_expand_cr = 2
let delimitMate_expand_inside_quotes = 1


noremap <c-s> :VsnipOpenVsplit<CR>

" copilot that everybody digs
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
nnoremap <leader>pe :Copilot enable<CR>
nnoremap <leader>pd :Copilot disable<CR>
let g:copilot_no_tab_map = v:true

set completeopt=menu,menuone,noselect
" *** plugin setting ends ***

" *** others ***
set ai et ts=2 sw=2
" do not use space when indenting in .go
autocmd BufRead *.go :set noet
" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=cro
autocmd FocusLost * redraw!

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
set pastetoggle=<F2>
set sb spr " split
set encoding=utf-8
set wildmode=longest,list,full
set hls ic scs is " search
set vb t_vb=
set iskeyword+=:
set shellslash
" Works if your vim has clipboard feature, make yp manupilate with system clipboard.
" If `vim --version` gives -clipboard, or :echo has('clipboard') gives 0,
" that means your vim does not support this, consider compile it from source.
" (I think neovim often has this build in by default)
set clipboard^=unnamedplus
" Or, use this fallback(X11, xclip) to make works.
" vnoremap <silent> <leader>y :w !xclip -in -selection clipboard<CR><ESC>
" noremap <silent> <leader>p :r !xclip -out -selection clipboard<CR><ESC>

" Return to last edit position when opening file again
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

nnoremap <silent> <c-q> :q!<CR>
" :W force save with sudo
cabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" jump between {}
nnoremap <TAB> %
" " jump between selected boundrys in visual mode
vnoremap <TAB> o
" quick semicolon
nnoremap <leader>; A;<Esc>
" add space before and after a char
noremap <leader>s i<space><ESC>la<space><ESC>
" remove search highlights
nnoremap <silent> ,/ :nohlsearch<CR>

" //
autocmd BufRead,BufNewfile *.cpp,*.cxx,*.h,*.go,*.java,*.js noremap <leader>/ I// <ESC>$
autocmd BufRead,BufNewfile *.cpp,*.cxx,*.h,*.go,*.java,*.js noremap <leader>\ ^3x$
" /* */
autocmd BufRead,BufNewfile *.c noremap <leader>/ I/* <ESC>A */<ESC>hhh
autocmd BufRead,BufNewfile *.c noremap <leader>\ ^3x$xxx
" #
autocmd BufRead,BufNewfile *.py,*conf noremap <leader>/ I# <ESC>
autocmd BufRead,BufNewfile *.py,*conf noremap <leader>\ ^2x$
" "
autocmd BufRead,BufNewfile *.vim noremap <leader>/ I" <ESC>
autocmd BufRead,BufNewfile *.vim noremap <leader>\ ^2x$

" panel navigation
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k

" tabs and buffers
noremap <silent> <leader>[ <ESC>:tabp<CR> " previous tab
noremap <silent> <leader>] <ESC>:tabn<CR> " next tab
noremap <silent> <leader>' :ls<CR> " list buffer
noremap <silent> <leader>, :bp<CR> " previous buffer
noremap <silent> <leader>. :bn<CR> " next buffer

" script to compile and run single source code file,
" with and without input redirect
noremap <leader>c :w! \| !compiler "%:p"<CR>
noremap <leader>r :w! \| !compiler-red "%:p"<CR>
" make optioins
autocmd FileType cpp setlocal makeprg=g\+\+\ %\ \-g\ \-std\=c\+\+17\ \-Wall
autocmd FileType python setlocal makeprg=python3\ %
autocmd FileType sh setlocal makeprg=%
autocmd FileType go setlocal makeprg=go\ build\ -o\ %<\ %
" use F3 to make
noremap <F3> <ESC> :w <CR> :make <CR>
inoremap <F3> <ESC> :w <CR> :make <CR>
" F4 to run executable
noremap <F4> <ESC> :!./%<
inoremap <F4> <ESC> :!./%<
" F5 to run executable with input file 'inp'
noremap <F5> <ESC> :!./%< < inp<CR>
inoremap <F5> <ESC> :!./%< < inp<CR>

" Some basics:
nnoremap c "_c
" Perform dot commands over visual blocks:
vnoremap . :normal .<CR>
" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>
" Runs a script that cleans out tex build files whenever I close out of a .tex file.
autocmd VimLeave *.tex !texclear %
autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex
" using lsp to format
autocmd BufWritePre *.go,*.cpp,*.c,*.py,*.rs lua vim.lsp.buf.format()

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
        highlight! link DiffText MatchParen
endif

lua << EOF
require'hop'.setup {}

local wk = require("which-key")
wk.register(mappings, opts)

servers = {
  'gopls',
  'clangd',
  -- 'rust_analyzer',
  'pylyzer',
}

require('nvim-cmp-config')
require('lsp-config')
require('treesitter-config')
require('diagnostics')
require("rustaceanvim")
EOF
