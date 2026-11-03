return {
  {
    "ludovicchabant/vim-gutentags",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      require("notebook_tags").setup()
      vim.g.gutentags_ctags_executable = "/opt/homebrew/bin/ctags"
      vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/gutentags"
    end,
  },
}
