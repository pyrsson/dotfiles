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
local games   = { [[^(.*\.exe)$]], "(steam_app.*)" }

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
    move  = { "monitor_w-window_w-5", "monitor_h-window_w-5" },
    -- keep_aspect_ratio = true,
})

-- Dialogs
for _, title in ipairs(dialogs) do
    rule({ title = title }, { float = true, center = true })
end

-- Settings
rule({ class = "^(org.pulseaudio.pavucontrol)$" }, { float = true, move = panel.move, size = panel.size })

-- Games: tearing, fullscreen, workspace 2, keep rendering when unfocused
for _, title in ipairs(games) do
    rule({ title = title }, {
        immediate  = true,
        fullscreen = true,
        workspace  = "2",
        tag        = "+unfocused",
    })
end

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
rule({ class = "Bitwarden" },         { float = true })

rule({ class = "^(zen)$", workspace = "w[tv2-10]" }, { float = true })

rule({ class = "Spotify" },                                 { workspace = "3" })
rule({ class = "vesktop" },                                 { workspace = "3 silent" })
rule({ class = "com.slack.Slack" },                         { workspace = "3", tag = "+unfocused" })
rule({ class = "com.github.IsmaelMartinez.teams_for_linux" }, { workspace = "3", tag = "+unfocused" })

rule({ class = "steam" }, { workspace = "2 silent" })

rule({ class = ".*" }, { persistent_size = true })

--------------
--- LAYERS ---
--------------

hl.layer_rule({ match = { namespace = ".*" }, xray = false })

-- ags
hl.layer_rule({ match = { namespace = "ags-.*" }, animation = "fade" })

-- launcher
hl.layer_rule({ match = { namespace = "walker" }, blur = true, ignore_alpha = 0, animation = "fade" })

-- wlogout
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true, animation = "fade" })

------------------
--- WORKSPACES ---
------------------

local philips = "desc:Philips Consumer Electronics Company PHL 346P1C"
local msi     = "desc:Microstep MSI G273Q"

hl.workspace_rule({ workspace = "1", monitor = philips, default = true })
hl.workspace_rule({ workspace = "2", monitor = philips })
hl.workspace_rule({ workspace = "3", monitor = msi, default = true })
hl.workspace_rule({ workspace = "4", monitor = msi })

-- laptop
hl.workspace_rule({ workspace = "3", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
