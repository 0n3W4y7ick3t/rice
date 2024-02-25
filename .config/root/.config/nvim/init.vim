syntax on
filetype on
filetype plugin on
filetype indent on
let mapleader = "\<Space>"

noremap <leader>cf :tabe $MYVIMRC<CR>

autocmd BufWritePost $MYVIMRC :so $MYVIMRC
" automatically generates shortcuts after saving bookmark files
autocmd BufWritePost $HOME/.config/shell/bm-* :silent! !shortcuts

" shortcuts for command mode
source ~/.config/nvim/shortcuts.vim

" terminals
noremap ,n :sp term://%:p:h//zsh<CR>i
tnoremap ,, <c-\><c-n><c-w>w
noremap ,, <c-w>w
nnoremap Q :bd<CR>
nnoremap W :w<CR>

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
nnoremap <F2> :set invpaste paste?<CR>
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
" Or, use this fallback(X11, xclip) to make works.
" vnoremap <silent> <leader>y :w !xclip -in -selection clipboard<CR><ESC>
" noremap <silent> <leader>p :r !xclip -out -selection clipboard<CR><ESC>

" Return to last edit position when opening file again
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

if &ft == 'vim'
  noremap <Leader>/ I" <ESC>
  noremap <Leader>\ ^2xh<ESC>
endif
if &ft == 'confinit' || &ft == 'python' || &ft == 'conf'
  noremap <Leader>/ I# <ESC>
  noremap <Leader>\ ^2xh<ESC>
endif

nnoremap <silent> <c-q> :q!<CR>

" Perform dot commands over visual blocks:
vnoremap . :normal .<CR>
" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>
" jump between {}
nnoremap <TAB> %
" " jump between selected boundrys in visual mode
vnoremap <TAB> o
" quick semicolon
nnoremap <leader>; A;<Esc>
" remove search highlights
nnoremap <silent> ,/ :nohlsearch<CR>

" panel navigation
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k

noremap <silent> <leader>, :bp<CR> " previous buffer
noremap <silent> <leader>. :bn<CR> " next buffer

" enable truecolor if possible
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

set background=dark
colorscheme jellybeans
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
