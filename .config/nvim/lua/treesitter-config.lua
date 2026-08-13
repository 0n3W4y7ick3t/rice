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

-- ===== nvim-treesitter (main branch API) =====
local ts = require('nvim-treesitter')

-- ensure_installed replacement; async no-op if already installed.
-- markdown_inline is pulled in automatically by markdown's `requires`.
ts.install({
  'c', 'cpp', 'python', 'go', 'bash', 'lua', 'vim',
  'vimdoc', 'query', 'markdown', 'rust', 'javascript', 'yaml',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterSetup', {}),
  callback = function(ev)
    -- skip files > 100KB
    local max_filesize = 100 * 1024
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
    if ok and stats and stats.size > max_filesize then
      return
    end
    -- highlighting; fails silently when no parser is installed for the ft
    if not pcall(vim.treesitter.start, ev.buf) then
      return
    end
    -- indentation (experimental upstream)
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    -- incremental selection via nvim 0.12 built-in an/in node objects
    -- (gs/scope_incremental has no equivalent; flash.nvim HT covers it)
    local kopts = { buffer = ev.buf, remap = true, silent = true }
    vim.keymap.set('n', '<CR>', 'van', kopts) -- init_selection
    vim.keymap.set('x', '<CR>', 'an', kopts)  -- node_incremental
    vim.keymap.set('x', '<BS>', 'in', kopts)  -- node_decremental
  end,
})

-- ===== nvim-treesitter-textobjects (main branch API) =====
require('nvim-treesitter-textobjects').setup {
  select = {
    lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
    selection_modes = {
      ['@parameter.outer'] = 'v',
      ['@function.outer'] = 'v',
      ['@function.inner'] = 'v',
      ['@class.outer'] = '<c-v>',
    },
    include_surrounding_whitespace = false,
  },
  move = {
    set_jumps = true, -- whether to set jumps in the jumplist
  },
}

local sel = function(query, group)
  return function()
    require('nvim-treesitter-textobjects.select').select_textobject(query, group)
  end
end

local select_maps = {
  ['if'] = { '@function.inner', 'inner part of a function' },
  ['af'] = { '@function.outer', 'outer part of a function' },
  ['iP'] = { '@parameter.inner', 'inner part of a parameter' },
  ['aP'] = { '@parameter.outer', 'outer part of a parameter' },
  ['ic'] = { '@comment.inner', 'inner part of a comment' },
  ['ac'] = { '@comment.outer', 'outer part of a comment' },
  ['iC'] = { '@class.inner', 'inner part of a class' },
  ['aC'] = { '@class.outer', 'outer part of a class' },
}
for lhs, m in pairs(select_maps) do
  vim.keymap.set({ 'x', 'o' }, lhs, sel(m[1], 'textobjects'), { desc = m[2] })
end
-- capture renamed on main: @scope -> @local.scope
for _, lhs in ipairs({ 'as', 'is' }) do
  vim.keymap.set({ 'x', 'o' }, lhs, sel('@local.scope', 'locals'), { desc = 'language scope' })
end

local move = function(fn, query, group)
  return function()
    require('nvim-treesitter-textobjects.move')[fn](query, group)
  end
end

-- most motions are already mapped by vim-unimpaired
local move_maps = {
  { ']]', 'goto_next_start',     '@function.outer',    'textobjects' },
  { ']z', 'goto_next_start',     '@fold',              'folds' },
  { ']p', 'goto_next_start',     '@parameter.inner',   'textobjects' },
  { '[[', 'goto_previous_start', '@function.outer',    'textobjects' },
  { '[z', 'goto_previous_start', '@fold',              'folds' },
  { '[p', 'goto_previous_start', '@parameter.inner',   'textobjects' },
  { ']i', 'goto_next',           '@conditional.outer', 'textobjects' },
  { '[i', 'goto_previous',       '@conditional.outer', 'textobjects' },
}
for _, m in ipairs(move_maps) do
  vim.keymap.set({ 'n', 'x', 'o' }, m[1], move(m[2], m[3], m[4]), { desc = m[2] .. ' ' .. m[3] })
end
