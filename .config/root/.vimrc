syntax on
filetype on
filetype plugin on
filetype indent on
let mapleader = "\<Space>"
command CFG :tabe $MYVIMRC
autocmd BufWritePost $MYVIMRC :so $MYVIMRC

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

set ai et ts=2 sw=2
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
set hls ic scs is " search
set vb t_vb=
set iskeyword+=:
set shellslash

" :Q to quit without saving
command Q :q!
" :W force save with sudo
nnoremap <silent> <Leader>w :w<CR>
" comment
" comment //
autocmd BufRead,BufNewfile *.c,*.cpp,*.cxx,*.h,*.go,*.java noremap <Leader>/ I// <ESC>
" uncomment //
autocmd BufRead,BufNewfile *.c,*.cpp,*.cxx,*.h,*.go,*.java noremap <Leader>\ ^3xh<ESC>
" use `:set ft?` to find out current file's filetype
if &ft == 'vim'
  noremap <Leader>/ I" <ESC>
  noremap <Leader>\ ^2xh<ESC>
endif
if &ft == 'confinit' || &ft == 'python' || &ft == 'conf'
  noremap <Leader>/ I# <ESC>
  noremap <Leader>\ ^2xh<ESC>
endif

" jump between {}
nnoremap <TAB> %
" jump between selected boundrys in visual mode
vnoremap <TAB> o
" copy to sysem clipboard(X11, xclip)
vnoremap <silent> <Leader>y :w !xclip -in -selection clipboard<CR><ESC>

" Replace all is aliased to S.
nnoremap S :%s//g<Left><Left>
