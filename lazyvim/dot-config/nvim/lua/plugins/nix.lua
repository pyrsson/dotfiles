-- install nixd with nix profile install 'nixpkgs#nixd'
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          formatting = {
            command = { "nixfmt" },
          },
        },
      },
    },
  },
}
