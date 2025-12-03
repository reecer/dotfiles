---@type LazySpec
return {
  "mrcjkb/rustaceanvim",
  version = "^6", -- Recommended
  lazy = false, -- This plugin is already lazy
  -- on_attach = function(client, bufnr)
  --   local astrolsp = require "astrolsp"
  --
  --   -- Run AstroNvim default `on_attach` function to get regular LSP config
  --   astrolsp.on_attach(client, bufnr)
  init = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          local format_sync_grp = vim.api.nvim_create_augroup("RustaceanFormat", {})
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function() vim.lsp.buf.format() end,
            group = format_sync_grp,
          })
        end,
      },
    }
  end,
}
