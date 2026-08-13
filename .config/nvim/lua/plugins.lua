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
  -- version = '*' pins to release tags: :Lazy update moves tag-to-tag
  -- instead of tracking HEAD (only set where upstream tags actively)
  { 'lukas-reineke/indent-blankline.nvim', version = '*' },
  { 'stevearc/aerial.nvim',                version = '*' },
  'jreybert/vimagit',
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',
  'junegunn/fzf.vim',
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    },
  },
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
    dependencies = { "akinsho/toggleterm.nvim" }
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
    version = '*',
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
    'MeanderingProgrammer/render-markdown.nvim', -- in-editor markdown rendering
    version = '*',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {},
    config = function(_, opts)
      require('render-markdown').setup(opts)
      nmap('<leader>m', ':RenderMarkdown toggle<cr>', 'toggle markdown rendering')
    end
  },
  'nvim-lua/plenary.nvim',
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false, -- main branch does not support lazy-loading
    branch = 'main',
    -- main is a rolling branch with no release tags; pin a known-good commit
    commit = 'c9f9ed6c1892f629ea399f4ee7905f2686fa13f2',
    build = ":TSUpdate",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        commit = '898ee307df58f854d11cd7edd06472574d48014e',
      },
    },
  },
  { 'nvim-telescope/telescope.nvim', version = '*' },
  'szw/vim-maximizer',
  'mbbill/undotree',
  {
    -- successor to the archived neodev.nvim: configures lua_ls for nvim dev
    'folke/lazydev.nvim',
    version = '*',
    ft = 'lua',
    opts = {
      library = {
        -- load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    version = '*',
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
    init = function()
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
    version = '*',
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
    'folke/flash.nvim',
    event = 'VeryLazy',
    -- keep native f/F/t/T behaviour; flash only adds the labelled jump
    opts = { modes = { char = { enabled = false } } },
    keys = {
      { 'HH', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,        desc = 'Flash jump' },
      { 'HT', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end,   desc = 'Flash treesitter' },
    },
    init = function()
      vim.keymap.set('i', 'HH', function()
        vim.cmd('stopinsert')
        require('flash').jump()
      end, { noremap = true, silent = true, desc = 'Flash jump' })
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
		'dnlhc/glance.nvim',
		init=function ()
			-- Lua
			vim.keymap.set('n', 'gd', '<CMD>Glance definitions<CR>', { desc = 'Glance lsp definitions' })
			vim.keymap.set('n', 'gt', '<CMD>Glance type_definitions<CR>', { desc = 'Glance lsp type_definition' })
			vim.keymap.set('n', 'gr', '<CMD>Glance references<CR>', { desc = 'Glance lsp implementations' })
			vim.keymap.set('n', 'gI', '<CMD>Glance implementations<CR>', { desc = 'Glance lsp references' })
			vim.keymap.set('n', 'gR', '<CMD>Glance resume<CR>', { desc = 'Glance resume last list' })
		end
	},
  {
    'neovim/nvim-lspconfig',
    version = '*',
    dependencies = {
      {
        'williamboman/mason.nvim',
        version = '*',
        dependencies = { { 'williamboman/mason-lspconfig.nvim', version = '*' } },
        config = function()
          require('mason').setup()
          local mason_lspconfig = require 'mason-lspconfig'
          mason_lspconfig.setup {
            ensure_installed = {},
            -- servers are configured and enabled explicitly below
            -- (clangd/gopls/rust_analyzer/zls are managed by the system)
            automatic_enable = false,
          }
        end
      },
    },
    config = function()
      require 'lsp-mappings' -- import the global my_attach function
      -- blink.cmp provides the completion capabilities
      local ok, blink = pcall(require, 'blink.cmp')
      local capabilities = ok and blink.get_lsp_capabilities() or
          vim.lsp.protocol.make_client_capabilities()

      -- defaults applied to every server (Neovim 0.11+ vim.lsp.config API)
      vim.lsp.config('*', {
        capabilities = capabilities,
        on_attach = my_attach,
      })

      -- clangd has its special command line
      vim.lsp.config('clangd', {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--completion-style=detailed',
          '--function-arg-placeholders=false', -- disable annoying argument placeholders
          '--fallback-style=llvm',
        },
      })

      vim.lsp.config('ruff', {
        init_options = {
          settings = {
            -- Any extra CLI arguments for `ruff` go here.
            args = {},
          },
        },
        on_attach = function(client, _)
          -- Disable hover in favor of pylsp
          client.server_capabilities.hoverProvider = false
        end,
      })

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = { checkThirdParty = false },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = 'space',
                indent_size = '2', -- should be string
              },
            },
          },
        },
      })

      vim.lsp.config('pylsp', {
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
            },
          },
        },
      })

      vim.lsp.config('ts_ls', {
        init_options = {
          hostInfo = 'neovim',
          preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      })

      -- enable the servers (system-managed + mason-installed alike),
      -- but skip any whose binary is missing so we don't spam "not executable"
      local wanted = {
        'bashls',
        'cmake',
        'dockerls',
        'gopls',
        'golangci_lint_ls',
        'lua_ls',
        'marksman',
        'zls',
        'ts_ls',
        'clangd',
        'pylsp',
        'ruff',
        -- 'basedpyright',
      }
      local function available(name)
        local cfg = vim.lsp.config[name]
        local cmd = cfg and cfg.cmd
        if type(cmd) ~= 'table' then return true end -- function/unknown cmd: let nvim decide
        return vim.fn.executable(cmd[1]) == 1
      end
      local enabled = {}
      for _, name in ipairs(wanted) do
        if available(name) then enabled[#enabled + 1] = name end
      end
      vim.lsp.enable(enabled)

      -- files opened as startup arguments may have already fired FileType
      -- before vim.lsp.enable registered its autocmd; re-fire it so they attach
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == ''
            and vim.bo[buf].filetype ~= '' then
          vim.api.nvim_exec_autocmds('FileType', { buffer = buf, modeline = false })
        end
      end
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
        -- use the first formatter that is available
        javascript = { "prettierd", "prettier", stop_after_first = true },
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
  { 'saghen/blink.compat', version = '*', lazy = true, opts = {} },
  {
    'saghen/blink.cmp',
    version = '*',
    event = 'InsertEnter',
    dependencies = {
      'saghen/blink.compat',
      -- keep vsnip for snippet storage/expansion (~/.vsnip) and editing commands;
      -- cmp-vsnip surfaces those snippets in blink via blink.compat
      'hrsh7th/vim-vsnip',
      'hrsh7th/vim-vsnip-integ',
      'hrsh7th/cmp-vsnip',
    },
    opts = {
      -- expansion/jumping delegated to vsnip so ~/.vsnip snippets keep working
      snippets = {
        expand = function(snippet) vim.fn['vsnip#anonymous'](snippet) end,
        active = function(filter)
          if filter and filter.direction then
            return vim.fn['vsnip#jumpable'](filter.direction) == 1
          end
          return vim.fn['vsnip#available'](1) == 1
        end,
        jump = function(direction)
          local key = direction == 1 and '<Plug>(vsnip-jump-next)' or '<Plug>(vsnip-jump-prev)'
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), '', true)
        end,
      },
      keymap = {
        preset = 'none',
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<C-y>'] = { 'show', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'show', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        list = { selection = { preselect = true, auto_insert = false } },
        menu = { border = 'rounded' },
      },
      signature = { enabled = true, window = { border = 'rounded' } },
      -- wilder.nvim already handles cmdline (`:`/`/`/`?`)
      cmdline = { enabled = false },
      sources = {
        default = { 'lsp', 'path', 'vsnip', 'buffer', 'lazydev' },
        providers = {
          -- reuse the nvim-cmp vsnip source through the compat layer
          vsnip = { name = 'vsnip', module = 'blink.compat.source', score_offset = -3 },
          -- lazydev provides nvim API completions in lua files
          lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
    },
  },
  'nvim-lualine/lualine.nvim',
  { 'nvim-tree/nvim-web-devicons',   lazy = true },
  { 'bluz71/vim-nightfly-guicolors', lazy = false },
  { 'folke/tokyonight.nvim',         lazy = false, version = '*' },

  {
    'mrcjkb/rustaceanvim',
    version = '^9', -- upstream recommends pinning the major
    ft = 'rust' -- just for rust
  },
}, {
  -- no luarocks installed on this system; stops plugins with rockspecs
  -- (e.g. nvim-dap-python) from looping on a failing luarocks build
  rocks = { enabled = false },
})
