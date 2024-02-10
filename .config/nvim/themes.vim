let $THEME="tokyonight"
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
    set pumblend=40
endif
 
lua << EOF
-- tokyonight theme specials
require("tokyonight").setup {
  transparent = true,
  lualine_bold = true,
  style = "storm",
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  }
}

-- lualine setting
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'aerial', 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress' },
    lualine_z = {
      'location',
      { 'datetime', style='%H:%M'},
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {'buffers'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'tabs'}
  },
  winbar = {
  },
  inactive_winbar = {},
  extensions = {}
}
EOF

colorscheme $THEME

" tokyonight set backgroud to transparent already
" function SetHi ()
"   " removes vim backgroud color, make it transparent
"   hi SignColumn guibg=NONE
"   hi Normal guibg=NONE ctermbg=NONE
"   hi NonText guibg=NONE ctermbg=NONE
"   hi LineNr guibg=NONE ctermbg=NONE
" endfunction
"
" " <leader>b to remove vim backgroud color, make it transparent
" " use ]ob to refresh (dark), supported by pope/vim-unimpaired
" noremap <silent> <leader>b :call SetHi()<CR>

" call SetHi() " must in the end
