return {
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    opts = {
      -- whether to automatically load preview when
      -- entering another markdown buffer
      auto_load = true,
      -- close preview window on buffer delete
      close_on_bdelete = true,

      -- syntax = true,            -- enable syntax highlighting, affects performance

      theme = "dark", -- 'dark' or 'light'

      update_on_change = true,

      -- relevant if update_on_change is true
      throttle_at = 200000, -- start throttling when file exceeds this
      -- amount of bytes in size
      throttle_time = "auto", -- minimum amount of time in milliseconds
      -- that has to pass before starting new render
    },
    init = function()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- Used by the code bloxks
    },

    config = function()
      require("markview").setup()
    end,
  },
}
