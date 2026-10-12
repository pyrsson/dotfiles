local dsp = hl.dsp
local bind = hl.bind
local exec = dsp.exec_cmd

local locked = { locked = true }
local repeating = { repeating = true }
local lockrep = { locked = true, repeating = true }

local host = require("hyprland.host")

local screenshot_path = [[~/Pictures/Screenshots/"Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"]]

local resize_step = 100

-- gestures

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "overlay" })

-- Mod + 2-finger swipe: next/previous track
hl.gesture({
  fingers = 2,
  direction = "right",
  mods = "SUPER",
  action = function()
    hl.exec_cmd("playerctl next")
  end,
})
hl.gesture({
  fingers = 2,
  direction = "left",
  mods = "SUPER",
  action = function()
    hl.exec_cmd("playerctl previous")
  end,
})

-- apps / tools

bind("SUPER + A", exec("walker"), { description = "Run an Application" })
bind("SUPER + T", exec("uwsm-app -- ghostty +new-window"), { description = "Open a Terminal: ghostty" })
bind("SUPER + Escape", exec("loginctl lock-session"), { dont_inhibit = true, description = "Lock the Screen" })

bind("SUPER + V", exec("walker -m clipboard"))
bind("SUPER + B", exec("walker -m bitwarden"))
bind("SUPER + E", exec("uwsm-app -- strata"))
bind("SUPER + SHIFT + P", exec([[wl-mirror "$(hyprctl -j monitors | jq -r '.[] | select(.focused) | .name')"]]))

bind("SUPER + N", exec("vibepanel popover toggle notifications"))
bind("SUPER + U", exec("vibepanel popover toggle quick-settings"))

bind("CTRL + ALT + Delete", exec("wlogout --buttons-per-row=2"))

-- Screenshots
bind("SUPER + SHIFT + S", exec("grimblast --notify copysave area " .. screenshot_path))
bind("Print", exec("grimblast --notify copysave output " .. screenshot_path))
bind("ALT + Print", exec("grimblast --notify copysave active " .. screenshot_path))

-- media

bind("XF86AudioRaiseVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03+"), lockrep)
bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03-"), lockrep)
bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked)
bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)

bind("XF86AudioPlay", exec("playerctl play-pause"), locked)
bind("XF86AudioPause", exec("playerctl play-pause"), locked)
bind("XF86AudioNext", exec("playerctl next"), locked)
bind("XF86AudioPrev", exec("playerctl previous"), locked)

bind("XF86MonBrightnessUp", exec("brightnessctl --class=backlight set +10%"), lockrep)
bind("XF86MonBrightnessDown", exec("brightnessctl --class=backlight set 10%-"), lockrep)

bind("SUPER + SHIFT + N", exec("playerctl next"), { locked = true, description = "Next track" })
bind("SUPER + SHIFT + B", exec("playerctl previous"), { locked = true, description = "Previous track" })
bind("SUPER + SHIFT + ALT + mouse:275", exec("playerctl previous"))
bind("SUPER + SHIFT + ALT + mouse:276", exec("playerctl next"))

-- windows
bind("SUPER + Q", dsp.window.close())

-- Move (with hyprtagger, SUPER + arrows and SUPER + SHIFT + Up/Down are tag binds, see below)
for _, d in ipairs({
  { "Left", "left", true },
  { "Down", "down", true },
  { "Up", "up", true },
  { "Right", "right", true },
  { "H", "left" },
  { "J", "down" },
  { "K", "up" },
  { "L", "right" },
}) do
  local key, dir, arrow = d[1], d[2], d[3]
  if not (host.tagger and arrow) then
    bind("SUPER + " .. key, dsp.focus({ direction = dir }), repeating)
  end
  if not (host.tagger and (key == "Up" or key == "Down")) then
    bind("SUPER + SHIFT + " .. key, dsp.window.move({ direction = dir }))
  end
  bind("SUPER + SHIFT + CTRL + " .. key, dsp.window.move({ monitor = dir, follow = true })) -- to monitor
  -- Monitors
  bind("SUPER + ALT + " .. key, dsp.focus({ monitor = dir }))
  -- Move whole workspace to monitor
  bind("SUPER + SHIFT + ALT + " .. key, dsp.workspace.move({ monitor = dir }))
end

-- Groups
bind("SUPER + Comma", dsp.window.move({ direction = "left", group_aware = true }))
bind("SUPER + Period", dsp.window.move({ direction = "right", group_aware = true }))
bind("SUPER + W", dsp.group.toggle(), { description = "Toggle tabbed (group)" })
bind("SUPER + O", dsp.group.next())
bind("SUPER + SHIFT + O", dsp.group.prev())

-- Sizing
if not host.tagger then
  bind("SUPER + R", dsp.layout("splitratio 1.0 exact"))
  bind("SUPER + CTRL + R", dsp.layout("togglesplit"))
end
bind("SUPER + CTRL + H", dsp.window.resize({ x = -resize_step, y = 0, relative = true }), repeating)
bind("SUPER + CTRL + L", dsp.window.resize({ x = resize_step, y = 0, relative = true }), repeating)
bind("SUPER + CTRL + K", dsp.window.resize({ x = 0, y = -resize_step, relative = true }), repeating)
bind("SUPER + CTRL + J", dsp.window.resize({ x = 0, y = resize_step, relative = true }), repeating)

bind("SUPER + F", dsp.window.fullscreen({ mode = "maximized" }))
bind("SUPER + M", dsp.window.fullscreen_state({ internal = 2, client = 0 }), { description = "Maximize to edges" })
bind("SUPER + SHIFT + F", dsp.window.fullscreen({ mode = "fullscreen" }))
bind("SUPER + C", dsp.window.center())

-- Floating
bind("SUPER + G", dsp.window.float({ action = "toggle" }))
bind("SUPER + SHIFT + D", dsp.focus({ window = "floating" }))

-- Mouse
bind("SUPER + mouse:272", dsp.window.drag(), { mouse = true })
bind("SUPER + mouse:273", dsp.window.resize(), { mouse = true })

-- Kept from the old Hyprland config
bind(
  "SUPER + ALT + F",
  dsp.window.fullscreen_state({ internal = 0, client = 3 }),
  { description = "Toggle fake fullscreen" }
)
bind("SUPER + SHIFT + ALT + Q", exec("hyprctl kill"), { description = "Pick and kill a window" })

-- workspaces

-- Number row by keycode (layout independent): code:10 = 1 ... code:18 = 9
-- With hyprtagger, SUPER (+ SHIFT/CTRL) + 1-9 are tags instead of workspaces
local tags = host.tagger and require("hyprtagger")
for i = 1, 9 do
  local key = "code:" .. (i + 9)
  if tags then
    bind("SUPER + " .. key, tags.action.view(i))
    bind("SUPER + SHIFT + " .. key, tags.action.tag(i))
    bind("SUPER + CTRL + " .. key, tags.action.toggleview(i))
    bind("SUPER + CTRL + SHIFT + " .. key, tags.action.toggletag(i))
  else
    bind("SUPER + " .. key, dsp.focus({ workspace = i }))
    bind("SUPER + SHIFT + " .. key, dsp.window.move({ workspace = i, follow = true }))
  end
  bind("SUPER + ALT + " .. key, dsp.workspace.move({ monitor = i - 1 })) -- old: move workspace to monitor N
end

-- hyprtagger: dwl-style tags and master/stack layout
if tags then
  local a = tags.action
  bind("SUPER + code:19", a.view_all(), { description = "View all tags" }) -- 0
  bind("SUPER + SHIFT + code:19", a.tag_all(), { description = "Tag window with all tags" })
  bind("SUPER + Tab", a.view_prev(), { description = "Previous tag view" })

  bind("SUPER + Return", a.zoom(), { description = "Swap with master" })
  bind("SUPER + Down", a.focusstack(1), repeating)
  bind("SUPER + Up", a.focusstack(-1), repeating)
  bind("SUPER + SHIFT + Down", a.movestack(1))
  bind("SUPER + SHIFT + Up", a.movestack(-1))
  bind("SUPER + Left", a.setmfact(-0.05), repeating)
  bind("SUPER + Right", a.setmfact(0.05), repeating)
  bind("SUPER + I", a.incnmaster(1), { description = "More masters" })
  bind("SUPER + D", a.incnmaster(-1), { description = "Fewer masters" })
  bind("SUPER + Space", a.cycle_layout(), { description = "Cycle layout" })
end

bind("SUPER + P", dsp.focus({ workspace = "previous" }))
bind("SUPER + S", dsp.workspace.toggle_special("overlay"))

bind("SUPER + Page_Down", dsp.focus({ workspace = "r+1" }))
bind("SUPER + Page_Up", dsp.focus({ workspace = "r-1" }))
bind("SUPER + CTRL + Page_Down", dsp.window.move({ workspace = "r+1", follow = true }))
bind("SUPER + CTRL + Page_Up", dsp.window.move({ workspace = "r-1", follow = true }))

-- Mouse wheel (rate limited by binds.scroll_event_delay, see general.lua)
bind("SUPER + mouse_down", dsp.focus({ workspace = "r+1" }))
bind("SUPER + mouse_up", dsp.focus({ workspace = "r-1" }))
bind("SUPER + CTRL + mouse_down", dsp.window.move({ workspace = "r+1", follow = true }))
bind("SUPER + CTRL + mouse_up", dsp.window.move({ workspace = "r-1", follow = true }))

bind("SUPER + mouse_right", dsp.focus({ direction = "right" }))
bind("SUPER + mouse_left", dsp.focus({ direction = "left" }))
bind("SUPER + CTRL + mouse_right", dsp.window.move({ direction = "right" }))
bind("SUPER + CTRL + mouse_left", dsp.window.move({ direction = "left" }))

bind("SUPER + SHIFT + mouse_down", dsp.focus({ direction = "right" }))
bind("SUPER + SHIFT + mouse_up", dsp.focus({ direction = "left" }))
bind("SUPER + CTRL + SHIFT + mouse_down", dsp.window.move({ direction = "right" }))
bind("SUPER + CTRL + SHIFT + mouse_up", dsp.window.move({ direction = "left" }))

-- other (old)

bind("SUPER + SHIFT + C", exec("hyprpicker -a"), { description = "Pick color (Hex) >> clipboard" })
bind("CTRL + SUPER + V", exec("pavucontrol"))
bind("CTRL + SUPER + SHIFT + V", exec("easyeffects"))
