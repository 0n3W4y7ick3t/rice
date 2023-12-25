let $THEME="nightfly"
set background=dark
autocmd BufWritePost ~/.config/nvim/themes.vim :so $MYVIMRC

if !has('gui_running')
  set t_Co=256
endif

" enable truecolor
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
 
function SetHi ()
  " gitgutter
  hi GitGutterAdd    guifg=#009900 ctermfg=2 guibg=NONE
  hi GitGutterChange guifg=#bbbb00 ctermfg=3 guibg=NONE
  hi GitGutterDelete guifg=#ff2222 ctermfg=1 guibg=NONE
  " removes vim backgroud color, make it transparent
  hi SignColumn guibg=NONE
  hi Normal guibg=NONE ctermbg=NONE
  hi NonText guibg=NONE ctermbg=NONE
  hi LineNr guibg=NONE ctermbg=NONE
endfunction

" if using airline
let g:airline_theme=$THEME
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
autocmd BufWritePost ~/.config/nvim/themes.vim :AirlineRefresh
" if using lightline
" let g:lightline = { 'colorscheme': dracula' }
colorscheme $THEME

call SetHi() " must in the end
