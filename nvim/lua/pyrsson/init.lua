if vim.g.vscode then
    -- VSCode extension
    -- require("pyrsson.autocmds")
    -- require("pyrsson.keymaps")
else
    -- ordinary Neovim
    require("pyrsson.autocmds")
    require("pyrsson.packer")
    require("pyrsson.keymaps")
    require("pyrsson.set")
    -- require("pyrsson.materialtheme")
    require("pyrsson.tokyonight")
    -- require("pyrsson.kanagawa")
end

