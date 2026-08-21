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
" ugly trick, some terminal can't differenciate <c-i> and <tab>
nnoremap <c-[> <c-i>
nnoremap <c-]> <c-o>
set showmode
set sb spr " split
set encoding=utf-8
set wildmode=longest,list,full
set hls ic scs is " search
set vb t_vb=
set iskeyword+=:
set shellslash
set foldmethod=manual
set clipboard^=unnamedplus
cabbrev W execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
]])
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- autocommands
-- disable annoying diagnostic for env files
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.env",
  callback = function() vim.diagnostic.enable(false) end,
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
vim.opt.colorcolumn = "80"

-- regenerate the keybindings doc (md + pdf) after saving hyprland configs
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*/hypr/hyprland.lua", "*/hypr/machine.lua*" },
  callback = function()
    local function done(code)
      vim.schedule(function()
        if code == 0 then
          vim.notify("keybindings doc regenerated", vim.log.levels.INFO)
        else
          vim.notify("hypr-keybindings-doc failed", vim.log.levels.WARN)
        end
      end)
    end
    if vim.system then
      vim.system({ "hypr-keybindings-doc", "--pdf" }, {}, function(out) done(out.code) end)
    else
      vim.fn.jobstart({ "hypr-keybindings-doc", "--pdf" }, { on_exit = function(_, code) done(code) end })
    end
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
