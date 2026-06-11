-- AL (Microsoft Business Central Application Language) support
--
-- Filetype detection + tree-sitter grammar from SShadowS/tree-sitter-al.
-- No LSP: Microsoft's AL language server is VS Code-only, so editing is
-- syntax-only from nvim's side. Compile via `alc` on the command line.

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      vim.filetype.add {
        extension = { al = 'al' },
      }

      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.al = {
        install_info = {
          url = 'https://github.com/SShadowS/tree-sitter-al',
          files = { 'src/parser.c', 'src/scanner.c' },
          branch = 'main',
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        },
        filetype = 'al',
      }

      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, 'al')
      return opts
    end,
  },
}
