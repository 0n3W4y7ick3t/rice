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
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'iamcco/markdown-preview.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-context'
" Plug 'wellle/context.vim'
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
Plug 'puremourning/vimspector'
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
" <leader>b to remove vim backgroud color, make it transparent
" use ]ob to refresh (dark), supported by pope/vim-unimpaired
noremap <silent> <leader>b :call Removebg()<CR>
" shortcuts for command mode
source ~/.config/nvim/shortcuts.vim

" *** plugin settings ***
" lua plugins are configured in the bottom
nnoremap <leader>m <Plug>MarkdownPreviewToggle
noremap <silent> <leader><CR> :MaximizerToggle<CR>
noremap <silent> <leader>u :UndotreeToggle<CR>

" copilot that everybody digs
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
nnoremap <leader>pe :Copilot enable<CR>
nnoremap <leader>pd :Copilot disable<CR>
let g:copilot_no_tab_map = v:true

let g:vimspector_enable_mappings = 'HUMAN'
hi TreesitterContextBottom gui=underline guisp=Grey

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

nnoremap <silent> <leader>g :Goyo<CR>

" finders! telescope and fzf
nnoremap <leader>tf <cmd>Telescope find_files<cr>
nnoremap <leader>tg <cmd>Telescope live_grep<cr>
nnoremap <leader>tb <cmd>Telescope buffers<cr>
nnoremap <leader>th <cmd>Telescope help_tags<cr>
nnoremap <leader>fg :RG 

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
" vnoremap <silent> <leader>y :w !xclip -in -selection clipboard<CR><ESC>
" noremap <silent> <leader>p :r !xclip -out -selection clipboard<CR><ESC>

" Return to last edit position when opening file again
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif

command Q :q! " :Q<CR> to quit without saving
nnoremap <silent> <c-q> :q<CR>
" :W force save with sudo
cabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
nnoremap <silent> <leader>q :q<CR>

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

" split: horizontal, vertical
noremap <silent> <leader>h :new<CR>
noremap <silent> <leader>v :vnew<CR>
noremap <leader>n :vs

" panel navigation
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k

" tabs and buffers
noremap <silent> <leader>t <ESC>:tabe<CR> " new tab
noremap <silent> <leader>[ <ESC>:tabp<CR> " previous tab
noremap <silent> <leader>] <ESC>:tabn<CR> " next tab
noremap <silent> <leader>' :ls<CR> " list buffer
noremap <silent> <leader>, :bp<CR> " previous buffer
noremap <silent> <leader>. :bn<CR> " next buffer

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
  require'treesitter-context'.setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- require('lspconfig')['gopls'].setup {
  --   capabilities = capabilities
  -- }
  -- require('lspconfig')['clangd'].setup {
  --   capabilities = capabilities
  -- }
  -- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.gopls.setup{
    capabilities = capabilities
}
lspconfig.clangd.setup{
    capabilities = capabilities
}
lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
EOF
