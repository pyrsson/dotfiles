-- Autostart
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local host = require("hyprland.host")
local WS   = require("hyprland.workspaces")

-- Same user services niri pulls in via ~/.config/systemd/user/niri.service.wants
-- (awww-bg and xdg-desktop-portal-gnome are niri specific and left out)
local services = {
    "awww.service",
    "elephant.service",
    "plasma-polkit-agent.service",
    "playerctld.service",
    "swayidle.service",
    "vibepanel.service",
}

hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start " .. table.concat(services, " "))

    -- niri: zen + ghostty open on "web" at startup
    hl.exec_cmd("uwsm app -- zen.desktop", { workspace = tostring(WS.web), tile = true })
    hl.exec_cmd("uwsm app -- ghostty", { workspace = WS.web .. " silent" })

    if host.name == "sidearm" then
        hl.exec_cmd("uwsm app -- steam-native.desktop", { workspace = WS.gaming .. " silent" })
        hl.exec_cmd("uwsm app -- vesktop.desktop", { workspace = WS.chat .. " silent" })
    elseif host.name == "thinkpad-x1" then
        hl.exec_cmd("uwsm app -- com.github.IsmaelMartinez.teams_for_linux.desktop", { workspace = WS.chat .. " silent" })
        hl.exec_cmd("uwsm app -- com.slack.Slack", { workspace = WS.chat .. " silent" })
    end
end)

-- Laptop touchpad: adaptive accel (global input uses flat)
hl.device({
    name          = "elan0673:00-04f3:3188-touchpad",
    accel_profile = "adaptive",
})
