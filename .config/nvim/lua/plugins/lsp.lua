return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lexical = {
          cmd = { "expert", "--stdio" },
          filetypes = { "elixir", "eelixir", "heex", "surface" },
          root_dir = function(fname)
            local lsputil = require "lspconfig.util"
            return lsputil.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
          end,
        },
      },
    },
  },
}
