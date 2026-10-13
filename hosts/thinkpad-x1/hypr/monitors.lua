-- Monitors and workspace placement for thinkpad-x1
-- Linked to ~/.config/hypr/hyprland/monitors.lua by mise.thinkpad-x1.toml

local philips = "desc:Philips Consumer Electronics Company PHL 346P1C"

hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 })
hl.monitor({ output = philips, mode = "3440x1440@100", position = "1920x-500", scale = 1, vrr = 0 })

return {
	-- workspace -> { monitor, default-for-monitor? }
	workspaces = { web = { "eDP-1", true }, chat = { "eDP-1" } },
	-- workspace -> scrolling layout direction
	scrolling = { chat = "right" },
}
