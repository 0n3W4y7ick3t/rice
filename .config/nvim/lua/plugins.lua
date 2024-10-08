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
  { 'wakatime/vim-wakatime', lazy = false },
  {
    "lmburns/lf.nvim",
    lazy = false,
    config = function()
      -- This feature will not work if the plugin is lazy-loaded
      vim.g.lf_netrw = 1

      require("lf").setup({
        escape_quit = false,
        default_action = "drop",
        default_actions = {
          ["<C-t>"] = "tabedit",
          ["<C-x>"] = "split",
          ["<C-v>"] = "vsplit",
          ["<C-o>"] = "tab drop",
          ["<C-e>"] = "edit",
        },
        border = "rounded",
      })

      vim.keymap.set("n", "<a-f>", "<Cmd>Lf<CR>")

      vim.api.nvim_create_autocmd("User", {
        pattern = "LfTermEnter",
        callback = function(a)
          vim.api.nvim_buf_set_keymap(a.buf, "t", "q", "q", { nowait = true })
        end,
      }
      )
    end,
    requires = { "toggleterm.nvim" }
  },
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    version = '*',
    config = function()
      -- toggleterm setup
      require("toggleterm").setup {
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        -- use [num]open_mapping to open the num-th terminal
        open_mapping = [[<c-\>]],
      }

      -- custom term: lazygit
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
    build = ":TSUpdate",
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
    config = function()
      vim.cmd([[
        let delimitMate_expand_cr = 2
        let delimitMate_expand_inside_quotes = 1
      ]])
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
      {
        'rcarriga/nvim-dap-ui',
        opts = {},
        dependencies = { 'nvim-neotest/nvim-nio' }
      },
    },
    config = function()
      local dap = require('dap')
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
        name = 'lldb'
      }
      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          -- CHANGE THIS to your path!
          command = 'codelldb',
          args = { "--port", "${port}" },
        }
      }

      -- c, cpp, rust
      dap.configurations.cpp = {
        {
          name = 'Launch',
          type = 'codelldb',
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
      {
        'williamboman/mason.nvim',
        dependencies = 'williamboman/mason-lspconfig.nvim',
        config = function()
          require('mason').setup()
          local mason_lspconfig = require 'mason-lspconfig'
          mason_lspconfig.setup {
            ensure_installed = {},
            -- I manage these with the system
            automatic_installation = { exclude = { 'clangd', 'gopls', 'rust_analyzer', 'zls' } },
          }
        end
      },
    },
    init = function()
      require 'lsp-mappings' -- import my_attach function
      local cap = vim.lsp.protocol.make_client_capabilities()
      local capabilities = require('cmp_nvim_lsp').default_capabilities(cap)
      local servers = {
        'bashls',
        'cmake',
        'dockerls',
        'gopls',
        'golangci_lint_ls',
        'lua_ls',
        -- 'ruff_lsp',
        -- 'basedpyright',
        'marksman',
        'zls',
      }
      -- Update nvim-cmp capabilities and add them to each language server
      local lspconfig = require('lspconfig')
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          capabilities = capabilities,
          on_attach = my_attach,
          single_file_support = true,
        }
      end
      -- clangd has its special setting
      lspconfig.clangd.setup {
        capabilities = capabilities,
        on_attach = my_attach,
        single_file_support = true,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--function-arg-placeholders=false", -- disable annoying arguments placing
          "--fallback-style=llvm",
        },
      }

      lspconfig.ruff_lsp.setup {
        init_options = {
          settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
          }
        },
        on_attach = function(client, bufnr)
          if client.name == 'ruff_lsp' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end
        end
      }

      lspconfig.pylsp.setup {
        on_attach = my_attach,
        settings = {
          pylsp = {
            plugins = {
              -- formatter options
              black = { enabled = false },
              autopep8 = { enabled = true },
              yapf = { enabled = false },
              -- linter options
              -- pylint = { enabled = true, executable = "pylint" },
              pyflakes = { enabled = true },
              pycodestyle = { enabled = false },
              -- type checker
              pylsp_mypy = { enabled = true },
              -- auto-completion options
              jedi_completion = { fuzzy = true },
              -- import sorting
              pyls_isort = { enabled = true },
            }
          }
        },
        flags = {
          debounce_text_changes = 200,
        },
        capabilities = capabilities,
      }
    end
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>lf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
      },
    },
    -- Everything in opts will be passed to setup()
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { { "prettierd", "prettier" } },
      },
      -- Set up format-on-save
      -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
      -- Customize formatters
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      -- see https://github.com/stevearc/conform.nvim/blob/master/doc/advanced_topics.md#injected-language-formatting-code-blocks
      require("conform").formatters.injected = {
        -- Set the options field
        options = {
          -- Set individual option values
          ignore_errors = true,
          lang_to_formatters = {
            json = { "jq" },
          },
        },
      }
    end,
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
