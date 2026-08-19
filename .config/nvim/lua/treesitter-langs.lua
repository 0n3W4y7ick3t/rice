-- Parsers nvim-treesitter (main branch) should have. One list, two readers:
-- treesitter-config.lua installs them lazily at startup, and the yadm
-- bootstrap pre-builds them headless so a fresh machine's first nvim is quiet.
-- markdown_inline is pulled in automatically by markdown's `requires`.
return {
  'c', 'cpp', 'python', 'go', 'bash', 'lua', 'vim',
  'vimdoc', 'query', 'markdown', 'rust', 'javascript', 'yaml', 'typescript',
}
