-- Window, layer and workspace rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

local function rule(match, effects)
    effects.match = match
    hl.window_rule(effects)
end

-- Regexes
local pip     = [[^(Picture(-| )in(-| )[Pp]icture)$]]
local dialogs = {
    "^(Open File)(.*)$",
    "^(Select a File)(.*)$",
    "^(Choose wallpaper)(.*)$",
    "^(Open Folder)(.*)$",
    "^(Save As)(.*)$",
    "^(Library)(.*)$",
    "^(File Upload)(.*)$",
}
local games   = [[^(steam_app.*|.*\.exe|Minecraft.*)$]]
local chat    = [[^([Ss]potify|vesktop|discord|com\.slack\.Slack|[Ss]lack|com\.github\.IsmaelMartinez\.teams_for_linux|teams-for-linux)$]]

local WS = require("hyprland.workspaces")

-- Top-right corner panel placement (below the bar)
local panel   = { move = { "monitor_w-window_w-5", 44 }, size = { 640, "monitor_h*0.5" } }

-----------------
--- BORROWED ---
-----------------

rule({ class = "^(steam)$" },    { float = true })
rule({ class = "^(guifetch)$" }, { float = true }) -- FlafyDev/guifetch
rule({ title = [[^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$]] }, { float = true })

-- Picture-in-Picture
rule({ title = pip }, {
    float = true,
    pin   = true,
    size  = { 1280, 720 },
    move  = { "monitor_w-window_w-8", "monitor_h-window_h-8" }, -- bottom-right, like niri
    -- keep_aspect_ratio = true,
})

-- Dialogs
for _, title in ipairs(dialogs) do
    rule({ title = title }, { float = true, center = true })
end

-- Settings
rule({ class = "^(org.pulseaudio.pavucontrol)$" }, { float = true, move = panel.move, size = panel.size })

-- Games (same matches as niri): tearing, fullscreen, "gaming" workspace, keep rendering when unfocused
rule({ class = games, title = [[negative:^Battle\.net]] }, {
    immediate  = true,
    fullscreen = true,
    workspace  = tostring(WS.gaming),
    tag        = "+unfocused",
})

rule({ tag = "unfocused" }, { render_unfocused = true })

----------------
--- MY RULES ---
----------------

rule({ class = "^(blueman-manager)$" }, { float = true, move = panel.move, size = panel.size })

rule({ class = "^(nm-connection-editor)$" },       { float = true })
rule({ class = "^(nm-openconnect-auth-dialog)$" }, { float = true, stay_focused = true })
rule({ title = "^(Network Connections)$" },        { move = panel.move, size = panel.size })

rule({ title = "^(Easy Effects)$" }, { float = true })
rule({ title = "^(Extension)(.*)$" }, { float = true })

-- Floating tools (same as niri)
rule({ class = "Bitwarden" },                            { float = true })
rule({ class = "^steam$", title = "^Friends List$" },    { float = true })
rule({ class = [[^com\.github\.finefindus\.eyedropper$]] }, { float = true })
rule({ class = [[^io\.github\.lgse\.Strata$]] },         { float = true })

rule({ class = "^(zen)$", workspace = "w[tv2-10]" }, { float = true })

-- Chat apps -> "chat" workspace (niri app-ids + flatpak/Hyprland class names)
rule({ class = chat }, { workspace = WS.chat .. " silent" })
rule({ class = [[^(com\.slack\.Slack|[Ss]lack|com\.github\.IsmaelMartinez\.teams_for_linux|teams-for-linux)$]] }, { tag = "+unfocused" })

rule({ class = "^steam$" }, { workspace = WS.gaming .. " silent" })

rule({ class = ".*" }, { persistent_size = true })

--------------
--- LAYERS ---
--------------

hl.layer_rule({ match = { namespace = ".*" }, xray = false })

-- launcher
hl.layer_rule({ match = { namespace = "walker" }, blur = true, ignore_alpha = 0, animation = "fade" })

-- wlogout
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true, animation = "fade" })

------------------
--- WORKSPACES ---
------------------

-- Mirrors the workspace/output layout in niri/config.kdl + outputs.kdl
local host    = require("hyprland.host")
local philips = "desc:Philips Consumer Electronics Company PHL 346P1C"
local msi     = "desc:Microstep MSI G273Q"

-- workspace -> { monitor, default-for-monitor? }
local layouts = {
    ["sidearm"]     = { web = { philips, true }, gaming = { philips }, chat = { msi, true } },
    ["thinkpad-x1"] = { web = { "eDP-1", true }, chat = { "eDP-1" } },
}
local layout = layouts[host.name] or {}

for name, id in pairs(WS) do
    local spec = { workspace = tostring(id), default_name = name }
    if layout[name] ~= nil then
        spec.monitor = layout[name][1]
        spec.default = layout[name][2] or nil
    end
    hl.workspace_rule(spec)
end
