-- Autostart
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
--
-- Apps (zen, ghostty, bitwarden, steam, vesktop) are started from ~/.config/autostart
-- by uwsm's XDG autostart, same as under niri (see mise/dotfiles.toml).
-- Cursor and toolkit env vars come from ~/.config/environment.d/common.conf.

local WS = require("hyprland.workspaces")

-- Same user units niri pulls in via ~/.config/systemd/user/niri.service.wants
-- (awww-bg and xdg-desktop-portal-gnome are niri specific and left out)
local services = {
    "awww.service",
    "elephant.service",
    "playerctld.service",
    "swayidle.service",
    "vibepanel.service",
}

-- niri: `match app-id="zen|ghostty" at-startup=true` -> open-on-workspace "web".
-- Hyprland has no at-startup match, so enable the rule only for the first minute.
local startup_web = hl.window_rule({
    name      = "startup-web",
    match     = { class = [[^(zen|com\.mitchellh\.ghostty|ghostty)$]] },
    workspace = WS.web .. " silent",
})

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start " .. table.concat(services, " "))

    hl.timer(function()
        startup_web:set_enabled(false)
    end, { timeout = 60000, type = "oneshot" })
end)

-- The config is re-evaluated on reload, which recreates the rule enabled; turn it off again
-- (monitors already exist on reload, but not during the initial load at startup).
if hl.get_active_monitor() ~= nil then
    startup_web:set_enabled(false)
end
hl.on("config.reloaded", function()
    startup_web:set_enabled(false)
end)

-- Laptop touchpad: adaptive accel (global input uses flat)
hl.device({
    name          = "elan0673:00-04f3:3188-touchpad",
    accel_profile = "adaptive",
})
