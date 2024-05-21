vim.cmd([[
syntax on
filetype on
filetype plugin on
filetype indent on

" automatically generates shortcuts after saving bookmark files
autocmd BufWritePost $HOME/.config/shell/bm-* :silent! !shortcuts
" shortcuts for command mode
source $HOME/.config/nvim/shortcuts.vim

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
nnoremap <F2> :set invpaste paste?<cr>
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
cabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
]])
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- autocommands
-- disable annoying diagnostic for env files
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.env",
  callback = function() vim.diagnostic.disable(0) end,
})
-- automatically deletes all trailing whitespace and newlines at end of file
-- on save, reset cursor position
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[
    let currPos = getpos('.')
    %s/\s\+$//e
    %s/\n\+\%$//e
    cal cursor(currPos[1], currPos[2])
    ]])
  end,
})

-- return to last edit position when opening file again
-- CONFLICTS WITH auto-session
-- vim.api.nvim_create_autocmd("BufReadPost", {
--   pattern = "*",
--   callback = function()
--     vim.cmd([[
--     if line(''\"') >= 1 && line(''\"') <= line('$') && &ft !~# 'commit'
--     |   exe "normal! g`\""
--     endif
--     ]])
--   end,
-- })
