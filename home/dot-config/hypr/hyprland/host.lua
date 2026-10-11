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

return {
  name = read_hostname(),
}
