-- Hostname, read once at config load (used for per-machine settings)

local function read_hostname()
  local f = io.open("/etc/hostname", "r")
  if not f then
    return ""
  end
  local name = f:read("*l") or ""
  f:close()
  return name
end

local name = read_hostname()

return {
  name = name,
  -- hyprtagger (dwl-style tags) is single-monitor only
  tagger = name == "thinkpad-x1",
}
