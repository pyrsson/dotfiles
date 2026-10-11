-- Autostart apps with uwsm
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local function hostname()
    local f = io.open("/etc/hostname", "r")
    if not f then
        return ""
    end
    local name = f:read("*l") or ""
    f:close()
    return name
end

local host = hostname()

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- zen.desktop", { workspace = "1", tile = true })

    if host == "sidearm" then
        hl.exec_cmd("uwsm app -- ghostty", { workspace = "1 silent" })
        hl.exec_cmd("uwsm app -- steam-native.desktop", { workspace = "2 silent" })
        hl.exec_cmd("uwsm app -- vesktop.desktop", { workspace = "3 silent" })
    elseif host == "thinkpad-x1" then
        hl.exec_cmd("uwsm app -- ghostty", { workspace = "2 silent" })
        hl.exec_cmd("uwsm app -- com.github.IsmaelMartinez.teams_for_linux.desktop", { workspace = "3 silent" })
        hl.exec_cmd("uwsm app -- com.slack.Slack", { workspace = "3 silent" })
    end
end)

-- Laptop touchpad: adaptive accel (global input uses flat)
hl.device({
    name          = "elan0673:00-04f3:3188-touchpad",
    accel_profile = "adaptive",
})
