-- Monitors and workspace placement for sidearm
-- Linked to ~/.config/hypr/hyprland/monitors.lua by mise.sidearm.toml

local philips = "desc:Philips Consumer Electronics Company PHL 346P1C"
local msi = "desc:Microstep MSI G273Q"

hl.monitor({ output = philips, mode = "3440x1440@100", position = "0x0", scale = 1, vrr = 0 })
hl.monitor({ output = "DP-3", disabled = true })
hl.monitor({ output = msi, mode = "2560x1440@120", position = "3440x-640", scale = 1, transform = 3 })

return {
	-- workspace -> { monitor, default-for-monitor? }
	workspaces = { web = { philips, true }, gaming = { philips }, chat = { msi, true } },
	-- workspace -> scrolling layout direction (portrait monitor: windows stack downwards)
	scrolling = { chat = "down", gaming = "right" },
}
