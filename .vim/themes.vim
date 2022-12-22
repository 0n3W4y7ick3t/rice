set background=dark
let $THEME='gruvbox'
" let $THEME='jellybeans'

colorscheme $THEME
set laststatus=2
let g:lightline = {
      \ 'colorscheme': $THEME,
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename','charvaluehex', 'modified', 'gitbranch' ] ]
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
" enable truecolor if possible
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
" remove background,
" :set background=dark to bring it up
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
" set cusor to a steady bar in insert mode
" and a steady block in other mode.
let &t_EI = "\e[2 q""]"
let &t_SI = "\e[6 q""]"
" autoreload vim to adapt to new themes after this file is saved.
autocmd BufWritePost ~/.vim/themes.vim :so $MYVIMRC
