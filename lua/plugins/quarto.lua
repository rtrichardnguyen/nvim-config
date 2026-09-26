-- plugins/quarto.lua
return {

  { -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
    -- for complete functionality (language features)
    "quarto-dev/quarto-nvim",
    dev = false,
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = "curly",
      },
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
    dependencies = {
      -- for language features in code cells
      -- configured in lua/plugins/lsp.lua
      "jmbuhr/otter.nvim",
    },
    lspFeatures = {
      languages = { "python" },
      chunks = "all",
      diagnostics = {
        enabled = true,
        triggers = { "BufWritePost" },
      },
      completion = {
        enabled = true,
      },
    },

    keys = {
      {
        "<localleader>nc",
        function()
          vim.api.nvim_put({ "", "```{python}", "", "", "", "```" }, "l", true, true)
          vim.cmd("normal! k")
          vim.cmd("startinsert")
        end,
        desc = "New Python cell",
      },

      {
        "<localleader>rc",
        function()
          require("quarto.runner").run_cell()
        end,
        desc = "Run cell",
      },

      {
        "<localleader>ra",
        function()
          require("quarto.runner").run_above()
        end,
        desc = "Run cell and above",
      },

      {
        "<localleader>rA",
        function()
          require("quarto.runner").run_all()
        end,
        desc = "Run all cells",
      },

      {
        "<localleader>rl",
        function()
          require("quarto.runner").run_line()
        end,
        desc = "Run line",
      },

      {
        "<localleader>r",
        function()
          require("quarto.runner").run_range()
        end,
        mode = "v",
        desc = "Run visual range",
      },

      {
        "<localleader>RA",
        function()
          require("quarto.runner").run_all(true)
        end,
        desc = "Run all cells of all languages",
      },
    },
    config = function(_, opts)
      require("quarto").setup(opts)
      require("quarto").activate()
    end,
  },
}
