if true then return {} end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    features = {
      signature_help = true,
      inlay_hints = true,
    },
    commands = {
      RuffOrganizeImports = {
        function()
          local ruff = vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf(), name = "ruff" })[1]
          ruff.request_sync("workspace/executeCommand", {
            command = "ruff.applyOrganizeImports",
            arguments = {
              { uri = vim.uri_from_bufnr(0), version = 0 },
            },
          })
        end,
      },
    },
    autocmds = {
      organize_imports = {
        {
          event = "BufWritePre",
          command = "RuffOrganizeImports",
          desc = "Organize imports with Ruff",
        },
      },
    },
    -- basedpyright = {
    --   settings = {
    --     pyright = {
    --       -- Using Ruff's import organizer
    --       disableOrganizeImports = true,
    --     },
    --     basedpyright = {
    --       analysis = {
    --         typeCheckingMode = "basic",
    --       },
    --     },
    --   },
    -- },
  },
}
