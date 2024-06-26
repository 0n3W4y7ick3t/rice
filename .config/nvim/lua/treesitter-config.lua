require 'treesitter-context'.setup {
  enable = true,
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "python", "go", "bash", "lua", "vim", "vimdoc", "query", "markdown", "rust" },
  sync_install = false,
  auto_install = false,

  -- List of parsers to ignore installing (or "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      node_decremental = "<BS>",
      scope_incremental = "gs",
    },
  },

  indent = {
    enable = true
  },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["if"] = { query = "@function.inner", desc = "inner part of a function" },
        ["af"] = { query = "@function.outer", desc = "outer part of a function" },
        ["iP"] = { query = "@parameter.inner", desc = "inner part of a parameter" },
        ["aP"] = { query = "@parameter.outer", desc = "outer part of a parameter" },
        ["ic"] = { query = "@comment.inner", desc = "inner part of a comment" },
        ["ac"] = { query = "@comment.outer", desc = "outer part of a comment" },
        ["iC"] = { query = "@class.inner", desc = "inner part of a class" },
        ["aC"] = { query = "@class.outer", desc = "outer part of a class" },
        -- You can also use captures from other query groups like `locals.scm`
        -- in scope and out scope are the same
        ["as"] = { query = "@scope", query_group = "locals", desc = "language scope" },
        ["is"] = { query = "@scope", query_group = "locals", desc = "language scope" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'v',  -- charwise
        ['@function.inner'] = 'v',  -- charwise
        ['@class.outer'] = '<c-v>', -- blockwise
      },

      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = false,
    },

    -- set the move motion, most of them are already mapped by vim-unimpaired
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        -- ["]m"] = "@function.outer",
        -- ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
        -- ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]]"] = { query = "@function.outer"},
        ["]z"] = { query = "@fold", query_group = "folds"},
        ["]p"] = { query = "@parameter.inner"},
      },
      -- goto_next_end = {
      --   ["]M"] = "@function.outer",
      --   ["]["] = "@class.outer",
      -- },
      goto_previous_start = {
        --   ["[m"] = "@function.outer",
        --   ["[["] = "@class.outer",
        ["[["] = { query = "@function.outer"},
        ["[z"] = { query = "@fold", query_group = "folds"},
        ["[p"] = { query = "@parameter.inner"},
      },
      -- goto_previous_end = {
      --   ["[M"] = "@function.outer",
      --   ["[]"] = "@class.outer",
      -- },
      -- -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]i"] = { query = "@conditional.outer"},
      },
      goto_previous = {
        ["[i"] = { query = "@conditional.outer"},
      }
    },
  },
}
