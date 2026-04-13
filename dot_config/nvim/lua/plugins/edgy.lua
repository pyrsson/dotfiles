return {
  "folke/edgy.nvim",
  opts = function(_, opts)
    opts.animate = {
      enabled = false,
    }

    -- remove help from bottom and put it on the right
    help_idx = nil
    for i, win in ipairs(opts.bottom) do
      if win.ft == "help" then
        help_idx = i
        break
      end
    end
    if help_idx then
      table.remove(opts.bottom, help_idx)
    end
    table.insert(opts.right, {
      ft = "help",
      size = { width = 0.4 },
      -- don't open help files in edgy that we're editing
      filter = function(buf)
        return vim.bo[buf].buftype == "help"
      end,
    })

    -- snacks terminal
    for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
      opts[pos] = opts[pos] or {}
      for _, win in ipairs(opts[pos]) do
        if win.ft == "snacks_terminal" then
          win.size = { height = 0.3 }
        end
      end
    end
  end,
}
