-- automatically install lazyvim, the plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local nmap = function(key, cmd, desc)
  vim.keymap.set('n', key, cmd, { desc = desc, noremap = true, silent = true })
end

require('lazy').setup({
  'lukas-reineke/indent-blankline.nvim',
  'stevearc/aerial.nvim',
  'jreybert/vimagit',
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',
  'junegunn/fzf.vim',
  {
    'vimwiki/vimwiki',
    ft = 'vimwiki',
    config = function()
      vim.cmd([[
        let g:vimwiki_ext2syntax = {}
        let g:vimwiki_list = [{
        \ 'auto_export': 0,
        \ 'path': '$VIMWIKI_DIR/contents',
        \ 'path_html': '$VIMWIKI_DIR/_site',
        \ 'template_path': '$VIMWIKI_DIR/templates',
        \ 'template_default': 'markdown',
        \ 'template_ext':'.html',
        \ 'syntax': 'markdown',
        \ 'ext': '.viki',
        \}]
      ]])
    end
  },
  {
    'ptzz/lf.vim',
    init = function()
      vim.g.lf_replace_netrw = 1
      vim.g.lf_command_override = 'lf -command "set hidden "'
      vim.g.lf_map_keys = 0
      nmap('<a-f>', ':Lf<cr>')
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    version = '*',
    opts = {
      size = 16,
    },
    config = function()
      -- use ToggleTerm to open lazygit
      local lazygit = require('toggleterm.terminal').Terminal:new({
        cmd = 'lazygit',
        dir = 'git_dir',
        direction = 'float',
        float_opts = {
          border = 'double',
        },
        -- function to run on opening the terminal
        on_open = function(term)
          vim.cmd('startinsert!')
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(_)
          vim.cmd('startinsert!')
        end,
      })
      nmap(',g', function() lazygit:toggle() end)
    end
  },
  {
    'voldikss/vim-floaterm',
    init = function()
      vim.g.floaterm_keymap_toggle = ',f'
      vim.g.floaterm_position = 'bottom'
      vim.g.floaterm_width = 0.99
      vim.g.floaterm_height = 0.6
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = 'v3.*',
    event = 'VeryLazy',
    keys = {
      { '<leader>bp', '<cmd>BufferLineTogglePin<CR>',            desc = 'Toggle Buffer Pin' },
      { '<leader>bc', '<cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Close Unpinned Buffers' },
    },
    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        numbers = 'buffer_id',
        always_show_bufferline = false
      }
    }
  },
  {
    'iamcco/markdown-preview.nvim', -- markdown preview
    ft = { 'markdown', 'vimwiki' },
    config = function()
      nmap('<leader>m', ':MarkdownPreviewToggle<cr>', 'markdown preview toggle')
    end
  },
  'nvim-lua/plenary.nvim',
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
  },
  'nvim-telescope/telescope.nvim',
  'szw/vim-maximizer',
  'mbbill/undotree',
  {
    'folke/neodev.nvim',
    opts = {},
    ft = 'lua',
    config = function()
      require('neodev').setup {}
      -- HACK: setup lua lsp at the same time
      local cap = vim.lsp.protocol.make_client_capabilities()
      local capabilities = require('cmp_nvim_lsp').default_capabilities(cap)
      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = my_attach,
        single_file_support = true,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' },
                },
                runtime = {
                  version = 'LuaJIT'
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME
                    -- '${3rd}/luv/library'
                    -- '${3rd}/busted/library',
                  }
                },
                format = {
                  enable = true,
                  defaultConfig = {
                    indent_style = 'space',
                    indent_size = '2', -- should be string
                  }
                },
              }
            })

            client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
          end
          return true
        end
      }
    end
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      keywords = {
        FIX = {
          icon = '', -- icon used for the sign, and in search results
          color = 'error', -- can be a hex color, or a named color
          alt = { 'FIXME', 'FIXIT', 'BUG', 'ISSUE', 'ERROR', 'ERR' },
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = '', color = 'info' },
        HACK = { icon = '󱡝', color = 'warning' },
        WARN = { icon = '', color = 'warning' },
        PERF = { icon = '󰾆', alt = { 'OPT', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        TEST = { icon = '󰙨', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
      },
      search = {
        command = 'rg',
        args = {
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--hidden',                -- also search under hidden folders
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    },
    config = function()
      local todo = require('todo-comments')
      nmap('[t', function() todo.jump_prev({ keywords = { 'TODO', 'HACK', 'WARN' } }) end)
      nmap(']t', function() todo.jump_next({ keywords = { 'TODO', 'HACK', 'WARN' } }) end)
      nmap('[o', function() todo.jump_prev({ keywords = { 'TEST', 'OPT' } }) end)
      nmap(']o', function() todo.jump_next({ keywords = { 'TEST', 'OPT' } }) end)
      nmap('[f', function() todo.jump_prev({ keywords = { 'FIXME', 'FIXIT', 'BUG', 'ISSUE', 'ERROR', 'ERR' } }) end)
      nmap(']f', function() todo.jump_next({ keywords = { 'FIXME', 'FIXIT', 'BUG', 'ISSUE', 'ERROR', 'ERR' } }) end)
    end
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {}
  },
  {
    'Raimondi/delimitMate', -- pairs
    init = function()
      vim.delimitMate_expand_cr = 2
      vim.delimitMate_expand_inside_quotes = 1
    end
  },
  {
    'smoka7/hop.nvim',
    version = '*',
    opts = {},
    init = function()
      nmap('HH', ':HopWord<cr>')
      vim.keymap.set('i', 'HH', '<ESC>:HopWord<cr>', { noremap = true, silent = true })
    end
  },
  {
    'gelguy/wilder.nvim',
    opts = { modes = { ':', '/', '?' } }
  },
  { 'numToStr/Comment.nvim', opts = {} },
  { 'rmagatti/auto-session', opts = {} },
  'machakann/vim-sandwich',
  'HiPhish/rainbow-delimiters.nvim',
  'tpope/vim-unimpaired',
  'tpope/vim-repeat',
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    ft = { 'go', 'c', 'cpp', 'rust', 'python' },
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', opts = {} },
      { 'rcarriga/nvim-dap-ui',            opts = {} },
    },
    config = function()
      local dap = require('dap')
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
        name = 'lldb'
      }

      -- c, cpp, rust
      dap.configurations.cpp = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      nmap('<F4>', function() dap.run_to_cursor() end)
      nmap('<F5>', function() dap.continue() end) -- start
      nmap('<F6>', function() dap.toggle_breakpoint() end)
      nmap('<F7>', function() dap.step_over() end)
      nmap('<F8>', function() dap.step_into() end)
      nmap('<F9>', function() dap.step_out() end)
      nmap('<F10>', function() require('dapui').toggle() end) -- tui
      nmap('<leader>db', function() dap.set_breakpoint(nil, nil, vim.fn.input('breakpoint with message: ')) end)
      nmap('<Leader>dr', function() dap.repl.toggle() end)
      nmap('<Leader>dl', function() dap.run_last() end)
      nmap('<Leader>dq', function() dap.terminate() end)
      local widgets = require('dap.ui.widgets')
      nmap('<Leader>dp', function() widgets.preview() end)
      nmap('<Leader>df', function() widgets.centered_float(widgets.frames) end)
      nmap('<Leader>ds', function() widgets.centered_float(widgets.scopes) end)
    end
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      local dapy = require('dap-python')
      local default = os.getenv('PYTHON_VENV_DIR')

      if default then
        dapy.setup(default .. '/debugpy/bin/python')
      else
        dapy.setup(os.getenv('HOME') .. '/.local/share/pyenv/debugpy/bin/python')
      end
      nmap('<leader>dm', function() dapy.test_method() end, 'python test method')
      nmap('<leader>dc', function() dapy.test_class() end, 'python test class')
      vim.keymap.set('v', '<leader>dv', function() dapy.debug_selection() end,
        { desc = 'python test visual selection', noremap = true, silent = true })
    end
  },
  {
    'leoluz/nvim-dap-go',
    ft = 'go', -- just for go, need dlv installed
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      local dapgo = require('dap-go')
      dapgo.setup()
      nmap('<Leader>dt', function() dapgo.debug_test() end, 'golang debug test')
    end
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim'
    },
  },
  {
    'hrsh7th/nvim-cmp',
    -- load cmp on InsertEnter
    event = 'InsertEnter',
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      '0n3W4y7ick3t/cmp-nvim-lsp-signature-help',
    },
  },
  'nvim-lualine/lualine.nvim',
  { 'nvim-tree/nvim-web-devicons',   lazy = true },
  { 'bluz71/vim-nightfly-guicolors', lazy = false },
  { 'folke/tokyonight.nvim',         lazy = false },

  {
    'mrcjkb/rustaceanvim',
    ft = 'rust' -- just for rust
  },
})
