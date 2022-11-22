
let $THEME='nightfly'
" jellybeans nord gruvbox dracula nightfly everforest catppuccin
set background=dark
autocmd BufWritePost ~/.config/nvim/themes.vim :so $MYVIMRC
autocmd BufWritePost ~/.config/nvim/themes.vim :AirlineRefresh

" enable truecolor
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif
" removes vim backgroud color, make it transparent
function Removebg ()
    hi Normal guibg=NONE ctermbg=NONE
    hi NonText guibg=NONE ctermbg=NONE
    hi LineNr guibg=NONE ctermbg=NONE
endfunction

let g:airline_theme=$THEME
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
" if use catppuccin
let g:catppuccin_flavour = 'frappe' " frappe, macchiato, mocha
colorscheme $THEME
