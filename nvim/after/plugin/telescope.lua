require('telescope').setup {
  pickers = {
    find_files = {
      find_command = { 'rg', '--files', '--hidden', '-g', '!.git' }
    },
    live_grep = {
      additional_args = function(opts)
        return { "--hidden", "-g", "!.git" }
      end
    },
  }
}
require("telescope").load_extension("lazygit")
require("telescope").load_extension("yaml_schema")
