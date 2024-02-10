syntax on
filetype on
filetype plugin on
filetype indent on
let mapleader = "\<Space>"

noremap <leader>cf :tabe $MYVIMRC<CR>
noremap <leader>cm :vs $HOME/.config/nvim/lua/mappings.lua<CR>
noremap <leader>ct :tabe $HOME/.config/nvim/themes.vim<CR>

autocmd BufWritePost $MYVIMRC :so $MYVIMRC
" automatically generates shortcuts after saving bookmark files
autocmd BufWritePost $HOME/.config/shell/bm-* :silent! !shortcuts

" automatically install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
" enhancement
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

" shortcuts for command mode
source ~/.config/nvim/shortcuts.vim

" *** plugin settings ***
" lua plugins are configured in the bottom
nnoremap <leader>m <Plug>MarkdownPreviewToggle
let g:mkdp_browser = 'firefox'
noremap <silent> <leader><CR> :MaximizerToggle<CR>
noremap <silent> <leader>u :UndotreeToggle<CR>
noremap <silent> HH :HopWord<CR>
inoremap <silent> HH <ESC>:HopWord<CR>
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

let g:lf_replace_netrw = 1
let g:lf_command_override = 'lf -command "set hidden"'
let g:lf_map_keys = 0
noremap <silent> <a-f> :Lf<CR>

" finders! telescope and fzf
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fa <cmd>Telescope aerial<cr>
nnoremap <leader>fr :RG 
" terminals
noremap ,n :sp term://%:p:h//zsh<CR>i
tnoremap ,, <c-\><c-n><c-w>w
noremap ,, <c-w>w
noremap ,s :FloatermSend<CR>
let g:floaterm_keymap_toggle = ',t'
let g:floaterm_position = 'bottom'
let g:floaterm_width = 1.0
let g:floaterm_height = 0.5
" pairs
let delimitMate_expand_cr = 2
let delimitMate_expand_inside_quotes = 1
" *** plugin setting ends ***

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
" remove search highlights
nnoremap <silent> ,/ :nohlsearch<CR>

" panel navigation
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k

" tabs and buffers
noremap <silent> <leader>[ <ESC>:tabp<CR> " previous tab
noremap <silent> <leader>] <ESC>:tabn<CR> " next tab
noremap <silent> <leader>, :bp<CR> " previous buffer
noremap <silent> <leader>. :bn<CR> " next buffer
   
" script to compile and run single source code file,
" with and without input redirect
noremap <leader>rc :w! \| !nvim-compiler "%:p"<CR>
noremap <leader>rr :w! \| !nvim-compiler-red "%:p"<CR>
noremap <leader>sv :VsnipOpenVsplit<CR>
noremap <leader>sy :VsnipYank<CR>
command FMT :lua vim.lsp.buf.format({aysnc=true})<CR>
" make optioins
autocmd FileType cpp setlocal makeprg=g\+\+\ %\ \-g\ \-std\=c\+\+17\ \-Wall
autocmd FileType python setlocal makeprg=python3\ %
autocmd FileType sh setlocal makeprg=%
autocmd FileType go setlocal makeprg=go\ build\ -o\ %<\ %

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

lua << EOF
require('hop').setup {}
require('Comment').setup{}
require('auto-session').setup {}
require('nvim-dap-virtual-text').setup()
require('dapui').setup()
require('telescope').load_extension('aerial')

require'nvim-cmp-config'
require'lsp-config'
require'treesitter-config'
require'diagnostics'
require'rustaceanvim'
require'git-signs'
require'mappings'
require'dap-config'
require'outline'
EOF

" themes and statusline settings
source ~/.config/nvim/themes.vim
