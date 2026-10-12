-- Window, layer and workspace rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

local function rule(match, effects)
  effects.match = match
  hl.window_rule(effects)
end

-- Regexes
local pip = [[^(Picture(-| )in(-| )[Pp]icture)$]]
local dialogs = {
  "^(Open File)(.*)$",
  "^(Select a File)(.*)$",
  "^(Choose wallpaper)(.*)$",
  "^(Open Folder)(.*)$",
  "^(Save As)(.*)$",
  "^(Library)(.*)$",
  "^(File Upload)(.*)$",
}
local games = [[^(steam_app.*|.*\.exe|Minecraft.*)$]]
local chat =
  [[^([Ss]potify|vesktop|discord|com\.slack\.Slack|[Ss]lack|com\.github\.IsmaelMartinez\.teams_for_linux|teams-for-linux)$]]

local WS = require("hyprland.workspaces")
local host = require("hyprland.host")

-- Top-right corner panel placement (below the bar)
local panel = { move = { "monitor_w-window_w-5", 44 }, size = { 640, "monitor_h*0.5" } }

rule({ title = [[^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$]] }, { float = true })

-- smart gaps
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, rounding = 0 })

-- float extension windows
hl.on("window.open", function(w)
  if w.class ~= "zen" then
    return
  end
  if w.initial_title ~= "Zen Browser" then
    return
  end

  local zen_windows = hl.get_windows({ class = "zen" })
  if #zen_windows <= 1 then
    return
  end

  hl.dispatch(hl.dsp.window.float({ action = "set", window = w }))

  local sub
  sub = hl.on("window.title", function(tw)
    if tw.address ~= w.address then
      return
    end
    if
      tw.title == ""
      or tw.title == "Zen Browser"
      or tw.title == "about:blank"
      or tw.title:match("^about:.*Zen Browser$")
    then
      return
    end

    sub:remove()

    if tw.title:match("^Extension:") then
      hl.dispatch(hl.dsp.window.resize({ x = 800, y = 600, window = tw }))
      hl.dispatch(hl.dsp.window.center({ window = tw }))
      hl.dispatch(hl.dsp.focus({ window = tw }))
    else
      hl.dispatch(hl.dsp.window.float({ action = "unset", window = tw }))
    end
  end)
end)

-- Picture-in-Picture
rule({ title = pip }, {
  float = true,
  pin = true,
  size = { 1280, 720 },
  move = { "monitor_w-window_w-8", "monitor_h-window_h-8" }, -- bottom-right
  -- keep_aspect_ratio = true,
})

-- Dialogs
for _, title in ipairs(dialogs) do
  rule({ title = title }, { float = true, center = true })
end

-- Settings
rule({ class = "^(org.pulseaudio.pavucontrol)$" }, { float = true, move = panel.move, size = panel.size })

-- Games: tearing, fullscreen, "gaming" workspace, keep rendering when unfocused
rule({ class = games, title = [[negative:^Battle\.net]] }, {
  immediate = true,
  fullscreen = true,
  workspace = tostring(WS.gaming),
  tag = "+unfocused",
})

rule({ tag = "unfocused" }, { render_unfocused = true })

rule({ class = "^(blueman-manager)$" }, { float = true, move = panel.move, size = panel.size })
-- rule({ class = "com.mitchellh.ghostty" }, { xray = true })

rule({ class = "^(nm-connection-editor)$" }, { float = true })
rule({ class = "^(nm-openconnect-auth-dialog)$" }, { float = true, stay_focused = true })
rule({ title = "^(Network Connections)$" }, { move = panel.move, size = panel.size })

rule({ title = "^(Easy Effects)$" }, { float = true })
rule({ title = "^(Extension)(.*)$" }, { float = true })

-- Floating tools
rule({ class = "Bitwarden" }, { float = true })
rule({ class = "^steam$", title = "^Friends List$" }, { float = true })
rule({ class = [[^com\.github\.finefindus\.eyedropper$]] }, { float = true })
rule({ class = [[^io\.github\.lgse\.Strata$]] }, { float = true })

rule({ class = "^(zen)$", workspace = "w[tv2-10]" }, { float = true })

-- Chat apps -> "chat" workspace (native + flatpak class names)
if host.tagger then
  rule({ class = chat }, { tags = tostring(WS.chat) }) -- hyprtagger plugin effect
else
  rule({ class = chat }, { workspace = WS.chat .. " silent" })
end
rule(
  { class = [[^(com\.slack\.Slack|[Ss]lack|com\.github\.IsmaelMartinez\.teams_for_linux|teams-for-linux)$]] },
  { tag = "+unfocused" }
)

rule({ class = "^steam$" }, { workspace = WS.gaming .. " silent" })

rule({ class = ".*" }, { persistent_size = true })
-- xray is enabled per-window instead of globally: layer fadeouts ignore layer xray rules and fall back to the global setting
rule({ class = ".*" }, { xray = true })

-- layers

hl.layer_rule({ match = { namespace = ".*" }, xray = false })
hl.layer_rule({ match = { namespace = "walker" }, blur = true, ignore_alpha = 0, animation = "fade" })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true, animation = "fade" }) -- wlogout
hl.layer_rule({
  match = { namespace = "^vibepanel-(.*popover|click-catcher|tooltip)$" },
  no_anim = true,
})

-- workspaces

-- Workspace -> monitor layout per host
local philips = "desc:Philips Consumer Electronics Company PHL 346P1C"
local msi = "desc:Microstep MSI G273Q"

-- workspace -> { monitor, default-for-monitor? }
local layouts = {
  ["sidearm"] = { web = { philips, true }, gaming = { philips }, chat = { msi, true } },
  ["thinkpad-x1"] = { web = { "eDP-1", true }, chat = { "eDP-1" } },
}
local layout = layouts[host.name] or {}

-- workspace -> scrolling layout direction (portrait monitor: windows stack downwards)
local scrolling = {
  ["sidearm"] = { chat = "down", gaming = "right" },
}
local scroll = scrolling[host.name] or {}

for name, id in pairs(WS) do
  local spec = { workspace = tostring(id), default_name = name }
  if layout[name] ~= nil then
    spec.monitor = layout[name][1]
    spec.default = layout[name][2] or nil
  end
  if scroll[name] ~= nil then
    spec.layout = "scrolling"
    spec.layout_opts = { direction = scroll[name] }
  end
  hl.workspace_rule(spec)
end
