vim.g.mapleader = ' '

-- Python provider: a dedicated venv (yadm bootstrap creates it with pynvim),
-- so remote plugins (wilder's cmdline completion) never depend on whichever
-- python3 mise puts first on PATH. Falls back to nvim's own search if absent.
local nvim_venv = vim.fn.stdpath('data') .. '/venv/bin/python'
if vim.fn.executable(nvim_venv) == 1 then vim.g.python3_host_prog = nvim_venv end

require 'neovim'
require 'plugins'
require 'treesitter-config'
require 'diagnostics'
require 'rustaceanvim'
require 'git-signs'
require 'whichkey' -- keymapping and doc
require 'outline'
require 'themes'
