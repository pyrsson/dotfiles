-- Keybinds, mirroring ~/.config/niri/keybinds.kdl where it makes sense for dwindle.
-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers/

local dsp  = hl.dsp
local bind = hl.bind
local exec = dsp.exec_cmd

local locked    = { locked = true }
local repeating = { repeating = true }
local lockrep   = { locked = true, repeating = true }

local WS = require("hyprland.workspaces")

local screenshot_path = [[~/Pictures/Screenshots/"Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"]]

---------------
--- HELPERS ---
---------------

-- Escape a string for use as an exact RE2 match
local function re_escape(s)
    return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?%{%}%|\\]", "\\%0"))
end

-- niri: focus-window-or-workspace-{up,down}
local function focus_or_workspace(direction, workspace)
    return function()
        local before = hl.get_active_window()
        hl.dispatch(dsp.focus({ direction = direction }))
        local after = hl.get_active_window()
        if before == nil or (after ~= nil and after.address == before.address) then
            hl.dispatch(dsp.focus({ workspace = workspace }))
        end
    end
end

-- niri: consume-or-expel-window-{left,right}, using groups as "columns"
local function consume_or_expel(direction)
    return function()
        local w = hl.get_active_window()
        if w == nil then
            return
        end
        if w.group ~= nil then
            hl.dispatch(dsp.window.move({ out_of_group = direction }))
        else
            hl.dispatch(dsp.window.move({ into_group = direction }))
        end
    end
end

-- niri: switch-preset-column-width (0.5 / 0.66667), via dwindle split ratio
local split_presets = { "1.0", "1.33333" }
local split_index   = 1
local function cycle_split_preset()
    split_index = split_index % #split_presets + 1
    hl.dispatch(dsp.layout("splitratio " .. split_presets[split_index] .. " exact"))
end

-- niri: set-column-width / set-window-height "+-10%" (of the monitor)
local function resize_percent(dx, dy)
    return function()
        local m = hl.get_active_monitor()
        if m == nil then
            return
        end
        hl.dispatch(dsp.window.resize({
            x        = math.floor(m.width * dx),
            y        = math.floor(m.height * dy),
            relative = true,
        }))
    end
end

-- niri: switch-focus-between-floating-and-tiling
local function toggle_float_focus()
    local w = hl.get_active_window()
    local floating = w ~= nil and w.floating
    hl.dispatch(dsp.window.cycle_next({ tiled = floating, floating = not floating }))
end

-- niri recent-windows: next/previous window, optionally only the same app
local function cycle_windows(forward, same_app)
    return function()
        if not same_app then
            hl.dispatch(dsp.window.cycle_next({ next = forward }))
            hl.dispatch(dsp.window.bring_to_top())
            return
        end

        local active = hl.get_active_window()
        if active == nil then
            return
        end
        local wins = hl.get_windows({ class = "^" .. re_escape(active.class) .. "$", mapped = true })
        if #wins < 2 then
            return
        end
        table.sort(wins, function(a, b) return a.stable_id < b.stable_id end)

        for i, w in ipairs(wins) do
            if w.address == active.address then
                local j = forward and (i % #wins + 1) or ((i - 2) % #wins + 1)
                hl.dispatch(dsp.focus({ window = "address:" .. wins[j].address }))
                hl.dispatch(dsp.window.bring_to_top())
                return
            end
        end
    end
end

-- niri: power-off-monitors (dpms must not be dispatched directly from a bind)
local function monitors_off()
    hl.timer(function()
        hl.dispatch(dsp.dpms({ action = "disable" }))
    end, { timeout = 500, type = "oneshot" })
end

----------------
--- GESTURES ---
----------------

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "vertical",   action = "special" })

-- niri: Mod+TouchpadScrollRight/Left
hl.gesture({ fingers = 2, direction = "right", mods = "SUPER", action = function() hl.exec_cmd("playerctl next") end })
hl.gesture({ fingers = 2, direction = "left",  mods = "SUPER", action = function() hl.exec_cmd("playerctl previous") end })

---------------------
--- APPS / TOOLS ---
---------------------

bind("SUPER + Space",  exec("walker"), { description = "Run an Application" })
bind("SUPER + Return", exec("uwsm-app -- ghostty +new-window"), { description = "Open a Terminal: ghostty" })
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
bind("Print",             exec("grimblast --notify copysave output " .. screenshot_path))
bind("ALT + Print",       exec("grimblast --notify copysave active " .. screenshot_path))

bind("SUPER + SHIFT + O", monitors_off, { description = "Power off monitors" })

-------------
--- MEDIA ---
-------------

bind("XF86AudioRaiseVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03+"),      lockrep)
bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.03-"),      lockrep)
bind("XF86AudioMute",        exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       locked)
bind("XF86AudioMicMute",     exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     locked)

bind("XF86AudioPlay",  exec("playerctl play-pause"), locked)
bind("XF86AudioPause", exec("playerctl play-pause"), locked)
bind("XF86AudioNext",  exec("playerctl next"),       locked)
bind("XF86AudioPrev",  exec("playerctl previous"),   locked)

bind("XF86MonBrightnessUp",   exec("brightnessctl --class=backlight set +10%"), lockrep)
bind("XF86MonBrightnessDown", exec("brightnessctl --class=backlight set 10%-"), lockrep)

-- Kept from the old Hyprland config
bind("SUPER + SHIFT + N",               exec("playerctl next"),     { locked = true, description = "Next track" })
bind("SUPER + SHIFT + B",               exec("playerctl previous"), { locked = true, description = "Previous track" })
bind("SUPER + SHIFT + ALT + mouse:275", exec("playerctl previous"))
bind("SUPER + SHIFT + ALT + mouse:276", exec("playerctl next"))

---------------
--- WINDOWS ---
---------------

bind("SUPER + Q", dsp.window.close())

-- Focus
bind("SUPER + Left",  dsp.focus({ direction = "left" }),  repeating)
bind("SUPER + Down",  dsp.focus({ direction = "down" }),  repeating)
bind("SUPER + Up",    dsp.focus({ direction = "up" }),    repeating)
bind("SUPER + Right", dsp.focus({ direction = "right" }), repeating)
bind("SUPER + H",     dsp.focus({ direction = "left" }),  repeating)
bind("SUPER + J",     focus_or_workspace("down", "r+1"),  repeating)
bind("SUPER + K",     focus_or_workspace("up",   "r-1"),  repeating)
bind("SUPER + L",     dsp.focus({ direction = "right" }), repeating)

-- Move
for _, d in ipairs({
    { "Left", "left" }, { "Down", "down" }, { "Up", "up" }, { "Right", "right" },
    { "H", "left" },    { "J", "down" },    { "K", "up" },  { "L", "right" },
}) do
    local key, dir = d[1], d[2]
    bind("SUPER + SHIFT + " .. key,        dsp.window.move({ direction = dir }))
    bind("SUPER + SHIFT + CTRL + " .. key, dsp.window.move({ monitor = dir, follow = true })) -- to monitor
end

-- Monitors
bind("SUPER + CTRL + Left",  dsp.focus({ monitor = "left" }))
bind("SUPER + CTRL + Down",  dsp.focus({ monitor = "down" }))
bind("SUPER + CTRL + Up",    dsp.focus({ monitor = "up" }))
bind("SUPER + CTRL + Right", dsp.focus({ monitor = "right" }))
bind("SUPER + ALT + H",      dsp.focus({ monitor = "left" }))
bind("SUPER + ALT + L",      dsp.focus({ monitor = "right" }))

-- Move whole workspace to monitor
bind("SUPER + SHIFT + ALT + H", dsp.workspace.move({ monitor = "left" }))
bind("SUPER + SHIFT + ALT + J", dsp.workspace.move({ monitor = "down" }))
bind("SUPER + SHIFT + ALT + K", dsp.workspace.move({ monitor = "up" }))
bind("SUPER + SHIFT + ALT + L", dsp.workspace.move({ monitor = "right" }))

-- Groups stand in for niri columns
bind("SUPER + Comma",  consume_or_expel("left"))
bind("SUPER + Period", consume_or_expel("right"))
bind("SUPER + W",      dsp.group.toggle(), { description = "Toggle tabbed (group)" })

-- Sizing
bind("SUPER + R",            cycle_split_preset, { description = "Cycle split preset (50% / 67%)" })
bind("SUPER + SHIFT + R",    dsp.layout("togglesplit"))
bind("SUPER + CTRL + R",     dsp.layout("splitratio 1.0 exact"))
bind("SUPER + Minus",         resize_percent(-0.1, 0), repeating)
bind("SUPER + plus",          resize_percent(0.1, 0),  repeating)
bind("SUPER + SHIFT + Minus", resize_percent(0, -0.1), repeating)
bind("SUPER + SHIFT + plus",  resize_percent(0, 0.1),  repeating)

bind("SUPER + F",         dsp.window.fullscreen({ mode = "maximized" }))
bind("SUPER + M",         dsp.window.fullscreen_state({ internal = 2, client = 0 }), { description = "Maximize to edges" })
bind("SUPER + SHIFT + F", dsp.window.fullscreen({ mode = "fullscreen" }))
bind("SUPER + C",         dsp.window.center())

-- Floating
bind("SUPER + D",         dsp.window.float({ action = "toggle" }))
bind("SUPER + SHIFT + D", toggle_float_focus)

-- Mouse
bind("SUPER + mouse:272", dsp.window.drag(),   { mouse = true })
bind("SUPER + mouse:273", dsp.window.resize(), { mouse = true })

-- Recent windows
bind("ALT + Tab",           cycle_windows(true,  false))
bind("ALT + SHIFT + Tab",   cycle_windows(false, false))
bind("ALT + grave",         cycle_windows(true,  true))
bind("ALT + SHIFT + grave", cycle_windows(false, true))
bind("SUPER + Tab",           cycle_windows(true,  false))
bind("SUPER + SHIFT + Tab",   cycle_windows(false, false))
bind("SUPER + grave",         cycle_windows(true,  true))
bind("SUPER + SHIFT + grave", cycle_windows(false, true))

-- Kept from the old Hyprland config
bind("SUPER + ALT + F",         dsp.window.fullscreen_state({ internal = 0, client = 3 }), { description = "Toggle fake fullscreen" })
bind("SUPER + SHIFT + ALT + Q", exec("hyprctl kill"), { description = "Pick and kill a window" })
bind("CTRL + SUPER + Minus",    dsp.window.resize({ x = 640, y = 480 }))

------------------
--- WORKSPACES ---
------------------

-- Number row by keycode (layout independent): code:10 = 1 ... code:18 = 9
for i = 1, 9 do
    local key = "code:" .. (i + 9)
    bind("SUPER + " .. key,         dsp.focus({ workspace = i }))
    bind("SUPER + SHIFT + " .. key, dsp.window.move({ workspace = i, follow = true }))
    bind("SUPER + ALT + " .. key,   dsp.workspace.move({ monitor = i - 1 })) -- old: move workspace to monitor N
end

bind("SUPER + P", dsp.focus({ workspace = "previous" }))
bind("SUPER + S", dsp.focus({ workspace = WS.chat }))

bind("SUPER + Page_Down",        dsp.focus({ workspace = "r+1" }))
bind("SUPER + Page_Up",          dsp.focus({ workspace = "r-1" }))
bind("SUPER + CTRL + Page_Down", dsp.window.move({ workspace = "r+1", follow = true }))
bind("SUPER + CTRL + Page_Up",   dsp.window.move({ workspace = "r-1", follow = true }))

-- Mouse wheel (rate limited by binds.scroll_event_delay, see general.lua)
bind("SUPER + mouse_down",        dsp.focus({ workspace = "r+1" }))
bind("SUPER + mouse_up",          dsp.focus({ workspace = "r-1" }))
bind("SUPER + CTRL + mouse_down", dsp.window.move({ workspace = "r+1", follow = true }))
bind("SUPER + CTRL + mouse_up",   dsp.window.move({ workspace = "r-1", follow = true }))

bind("SUPER + mouse_right",        dsp.focus({ direction = "right" }))
bind("SUPER + mouse_left",         dsp.focus({ direction = "left" }))
bind("SUPER + CTRL + mouse_right", dsp.window.move({ direction = "right" }))
bind("SUPER + CTRL + mouse_left",  dsp.window.move({ direction = "left" }))

bind("SUPER + SHIFT + mouse_down",        dsp.focus({ direction = "right" }))
bind("SUPER + SHIFT + mouse_up",          dsp.focus({ direction = "left" }))
bind("SUPER + CTRL + SHIFT + mouse_down", dsp.window.move({ direction = "right" }))
bind("SUPER + CTRL + SHIFT + mouse_up",   dsp.window.move({ direction = "left" }))

---------------------
--- OTHER (old) ---
---------------------

bind("SUPER + SHIFT + C",        exec("hyprpicker -a"), { description = "Pick color (Hex) >> clipboard" })
bind("CTRL + SUPER + V",         exec("pavucontrol"))
bind("CTRL + SUPER + SHIFT + V", exec("easyeffects"))

bind("SUPER + ALT + F12", exec([[fyi -a 'Shell' -A "Test1:I got it!" -A "Test2:Another action" -t 5000 'Test notification' "Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!"]]))
bind("SUPER + ALT + F11", exec([[fyi -u critical -a 'Hyprland keybind' "Urgent notification" "Ah hell no"]]))
