require('gitsigns').setup{
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc="next hunk"})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc="prev hunk"})

    -- Actions
    local desc = function(explain)
      return { desc = explain}
    end

    map('n', '<leader>hs', gs.stage_hunk, desc("stage hunk"))
    map('n', '<leader>hr', gs.reset_hunk, desc("discard hunk"))
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, desc("stage hunk"))
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, desc("discard hunk"))
    map('n', '<leader>hS', gs.stage_buffer, desc("stage whole buffer"))
    map('n', '<leader>hu', gs.undo_stage_hunk, desc("unstage hunk"))
    map('n', '<leader>hR', gs.reset_buffer, desc("discard whole buffer"))
    map('n', '<leader>hp', gs.preview_hunk, desc("preview hunk"))
    map('n', '<leader>hb', function() gs.blame_line{full=true} end, desc("blame line"))
    map('n', '<leader>tb', gs.toggle_current_line_blame, desc("toggle line blame"))
    map('n', '<leader>hd', gs.diffthis, desc("diff hunk"))
    map('n', '<leader>hD', function() gs.diffthis('~') end, desc("diff buffer"))
    map('n', '<leader>td', gs.toggle_deleted, desc("toggle deleted"))

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
