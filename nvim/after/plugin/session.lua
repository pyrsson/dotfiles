vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- get dirs for allowed sessions
local function allowed_dirs()
  local dirs = {}
  local vt = vim.fn.expand("~/vasttrafik/*", false, true)
  for _,v in ipairs(vt) do
    table.insert(dirs, v)
  end
  local work = vim.fn.expand("~/work/*", false, true)
  for _,v in ipairs(work) do
    table.insert(dirs, v)
  end
  local gh = vim.fn.expand("~/github/*", false, true)
  for _,v in ipairs(gh) do
    table.insert(dirs, v)
  end
  return dirs
end

local dirs = allowed_dirs()

require("auto-session").setup {
  log_level = "error",
  auto_session_allowed_dirs = dirs,
  auto_session_use_git_branch = true,
}
