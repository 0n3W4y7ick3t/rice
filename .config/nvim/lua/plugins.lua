-- automatically install lazyvim, the plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  'lukas-reineke/indent-blankline.nvim',
  'stevearc/aerial.nvim',
  'junegunn/goyo.vim',
  'jreybert/vimagit',
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',
  'junegunn/fzf.vim',
  {
    'vimwiki/vimwiki',
    init = function()
      vim.cmd([[
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
      ]])
    end
  },
  {
    'ptzz/lf.vim',
    init = function()
      vim.g.lf_replace_netrw = 1
      vim.g.lf_command_override = 'lf -command "set hidden"'
      vim.g.lf_map_keys = 0
      vim.keymap.set('n', '<a-f>', ':Lf<cr>', { noremap = true, silent = true })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
      size = 16,
    },
    init = function()
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        -- move between terminals and buffers
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
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
    "akinsho/bufferline.nvim",
    version = "v3.*",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<CR>",            desc = "Toggle Buffer Pin" },
      { "<leader>bc", "<cmd>BufferLineGroupClose ungrouped<CR>", desc = "Close Unpinned Buffers" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        numbers = "buffer_id",
        always_show_bufferline = false
      }
    }
  },
  {
    'iamcco/markdown-preview.nvim', -- markdown preview
    init = function()
      vim.keymap.set('n', '<leader>m', ':MarkdownPreviewToggle<cr>', { noremap = true, silent = true })
    end
  },
  'nvim-lua/plenary.nvim',
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
  },
  'nvim-telescope/telescope.nvim',
  'szw/vim-maximizer',
  'mbbill/undotree',
  { 'folke/neodev.nvim',     opts = {} },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      keywords = {
        FIX = {
          icon = "", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color
          alt = { "FIXME", "FIXIT", "BUG", "ISSUE", "ERROR", "ERR" },
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = { icon = "", color = "info" },
        HACK = { icon = "󱡝", color = "warning" },
        WARN = { icon = "", color = "warning" },
        PERF = { icon = "󰾆", alt = { "OPT", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "󰙨", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--hidden", -- also search under hidden folders
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    }
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
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
    version = "*",
    opts = {},
    init = function()
      vim.keymap.set({ 'n', 'i' }, 'HH', '<ESC>:HopWord<cr>', { noremap = true, silent = true })
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
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', opts = {} },
      { 'rcarriga/nvim-dap-ui',            opts = {} },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim"
    },
  },
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
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
    ft = "rust" -- just for rust
  },
})
