vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
require("auto-session").setup {
  log_level = "error",
  auto_session_suppress_dirs = { "~/vasttrafik", "~/github", "~/work", "~/", "/", "~/Downloads" },
}
