return {
  "eggplannt/composite-highlighting.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("composite-highlighting").setup({
      languages = {
        { parser = "gotmpl", extension = "tmpl" },
        { parser = "tera", extension = "tera" },
      },
    })
  end,
}
