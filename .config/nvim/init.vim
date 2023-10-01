syntax on
filetype on
filetype plugin on
filetype indent on
let mapleader = "\<Space>"

command CFG :tabe $MYVIMRC
command THEME :tabe ~/.config/nvim/themes.vim
autocmd BufWritePost $MYVIMRC :so $MYVIMRC
autocmd BufWritePost $MYVIMRC silent:LspRestart

" automatically install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
" enhancement
Plug 'jreybert/vimagit'
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'iamcco/markdown-preview.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'szw/vim-maximizer'
Plug 'github/copilot.vim'
Plug 'mbbill/undotree'
" edit
Plug 'LunarWatcher/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
" debug

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
" statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" colorscheme
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'dylanaraps/wal.vim'
call plug#end()

" themes and statusline settings
source ~/.config/nvim/themes.vim
" <Leader>b to remove vim backgroud color, make it transparent
" use ]ob to refresh (dark), supported by pope/vim-unimpaired
noremap <silent> <Leader>b :call Removebg()<CR>
" shortcuts for command mode
source ~/.config/nvim/shortcuts.vim

" *** plugin settings ***
" lua plugins are configured in the bottom
nnoremap <Leader>m <Plug>MarkdownPreviewToggle
noremap <silent> <Leader><CR> :MaximizerToggle<CR>
noremap <silent> <Leader>u :UndotreeToggle<CR>

" copilot that everybody digs
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" Ensure files are read as what I want:
let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
map <leader>i :VimwikiIndex<CR>
let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

noremap <F11> :FloatermSend<CR>
inoremap <F11> <ESC>:FloatermSend<CR>
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_position = 'bottom'
let g:floaterm_width = 1.0
let g:floaterm_height = 0.5

let g:lf_replace_netrw = 1
let g:lf_command_override = 'lf -command "set hidden"'
let g:lf_map_keys = 0
noremap <silent> <a-f> :Lf<CR>

" finders! telescope and fzf
nnoremap <leader>tf <cmd>Telescope find_files<cr>
nnoremap <leader>tg <cmd>Telescope live_grep<cr>
nnoremap <leader>tb <cmd>Telescope buffers<cr>
nnoremap <leader>th <cmd>Telescope help_tags<cr>
nnoremap <Leader>fg :RG 

noremap <c-s> :VsnipOpenVsplit<CR>

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
" vnoremap <silent> <Leader>y :w !xclip -in -selection clipboard<CR><ESC>
" noremap <silent> <Leader>p :r !xclip -out -selection clipboard<CR><ESC>

" Return to last edit position when opening file again
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

" :Q to quit without saving
command Q :q!
" :W force save with sudo
cabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
nnoremap <silent> <Leader>q :q<CR>

" jump between {}
nnoremap <TAB> %
" " jump between selected boundrys in visual mode
vnoremap <TAB> o
" quick semicolon
nnoremap <Leader>; A;<Esc>
" add space before and after a char
noremap <Leader>s i<space><ESC>la<space><ESC>
" remove search highlights
nnoremap <silent> ,/ :nohlsearch<CR>

" //
autocmd BufRead,BufNewfile *.cpp,*.cxx,*.h,*.go,*.java,*.js noremap <Leader>/ I// <ESC>$
autocmd BufRead,BufNewfile *.cpp,*.cxx,*.h,*.go,*.java,*.js noremap <Leader>\ ^3x$
" /* */
autocmd BufRead,BufNewfile *.c noremap <Leader>/ I/* <ESC>A */<ESC>hhh
autocmd BufRead,BufNewfile *.c noremap <Leader>\ ^3x$xxx
" #
autocmd BufRead,BufNewfile *.py,*conf noremap <Leader>/ I# <ESC>
autocmd BufRead,BufNewfile *.py,*conf noremap <Leader>\ ^2x$
" "
autocmd BufRead,BufNewfile *.vim noremap <Leader>/ I" <ESC>
autocmd BufRead,BufNewfile *.vim noremap <Leader>\ ^2x$

" split: horizontal, vertical
noremap <silent> <Leader>h :new<CR>
noremap <silent> <Leader>v :vnew<CR>
noremap <Leader>n :vs

" panel navigation
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k

" tabs and buffers
noremap <silent> <Leader>t <ESC>:tabe<CR> " new tab
noremap <silent> <Leader>[ <ESC>:tabp<CR> " previous tab
noremap <silent> <Leader>] <ESC>:tabn<CR> " next tab
noremap <silent> <Leader>' :ls<CR> " list buffer
noremap <silent> <Leader>, :bp<CR> " previous buffer
noremap <silent> <Leader>. :bn<CR> " next buffer

" script to compile and run single source code file,
" with and without input redirect
noremap <leader>c :w! \| !compiler "%:p"<CR>
noremap <leader>r :w! \| !compiler-red "%:p"<CR>
noremap <leader>i :vs "%:p:h/inp"<CR>:w inp<CR> " edit inp file
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

autocmd BufWritePre * let currPos = getpos(".")
" run format tools after saving
autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.vert,*.frag %!clang-format -style=llvm
autocmd BufWritePre *.go !gofmt -w %
autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
        highlight! link DiffText MatchParen
endif

lua <<EOF
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
  end
  local cmp = require("cmp")
  cmp.setup({

    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)", "")
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-next)", "")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
        end
      end, { "i", "s" }),

    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  }) -- end of cmp.setup()

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      -- { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require('lspconfig')['gopls'].setup {
    capabilities = capabilities
  }
  require('lspconfig')['clangd'].setup {
    capabilities = capabilities
  }
EOF
