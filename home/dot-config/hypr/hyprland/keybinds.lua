-- Keybinds
-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers/

local dsp  = hl.dsp
local bind = hl.bind
local exec = dsp.exec_cmd

local locked    = { locked = true }
local repeating = { repeating = true }
local lockrep   = { locked = true, repeating = true }
local release   = { release = true }

-- playerctl next, or skip to the end of the track if the player can't do "next"
local next_track = [[playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`]]

----------------
--- GESTURES ---
----------------

hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "vertical",   action = "special" })

------------
--- APPS ---
------------

bind("SUPER + A",              dsp.focus({ window = "class:Alacritty" }))
bind("SUPER + SHIFT + A",      exec("uwsm-app -- alacritty"))
bind("SUPER + Return",         dsp.focus({ window = "class:ghostty" }), locked)
bind("SUPER + SHIFT + Return", exec("uwsm-app -- ghostty"), locked)
bind("SUPER + Z",              dsp.focus({ window = "class:zen" }))
bind("SUPER + SHIFT + Z",      exec("uwsm-app -- zen-browser"))
bind("SUPER + SHIFT + S",      exec("grimblast copysave area ~/Pictures/Screenshots/screenshot-$(date +%F-%H-%M-%S).png"))
bind("SUPER + Super_L",        exec("walker"), release)
bind("SUPER + B",              exec("walker -m menus:bitwarden"))
bind("SUPER + Period",         exec("walker -m symbols"))

bind("SUPER + V", exec("walker -m clipboard"), { description = "Clipboard manager" })
-- bind("SUPER + V",       exec("pkill tofi || clippars | cliphist decode | wl-copy"))
-- bind("SUPER + ALT + V", exec("pkill tofi || clippars | cliphist delete | wl-copy"))

bind("CTRL + SHIFT + ALT + Delete", exec("pkill wlogout || wlogout -p layer-shell -b 2"))

bind("SUPER + SHIFT + C", exec("hyprpicker -a"), { description = "Pick color (Hex) >> clipboard" })

bind("Print", exec("grim - | wl-copy"), { locked = true, description = "Screenshot >> clipboard" })

-- session
bind("SUPER + Escape", exec("loginctl lock-session"), { description = "Lock" })

------------------
--- WORKSPACES ---
------------------

-- Number row by keycode (layout independent): code:10 = 1 ... code:18 = 9
for i = 1, 9 do
    local key = "code:" .. (i + 9)
    bind("SUPER + " .. key,         dsp.focus({ workspace = i }))
    bind("SUPER + SHIFT + " .. key, dsp.window.move({ workspace = i, follow = true }))
    bind("SUPER + ALT + " .. key,   dsp.workspace.move({ monitor = i - 1 })) -- move current workspace to monitor
end

bind("CTRL + SUPER + Right",      dsp.focus({ workspace = "+1" }))
bind("CTRL + SUPER + Left",       dsp.focus({ workspace = "-1" }))
bind("SUPER + mouse_up",          dsp.focus({ workspace = "+1" }))
bind("SUPER + mouse_down",        dsp.focus({ workspace = "-1" }))
bind("CTRL + SUPER + mouse_up",   dsp.focus({ workspace = "+1" }))
bind("CTRL + SUPER + mouse_down", dsp.focus({ workspace = "-1" }))

-- Special
bind("SUPER + S",         dsp.workspace.toggle_special("special"))
bind("SUPER + mouse:275", dsp.workspace.toggle_special("special"))

bind("CTRL + SUPER + SHIFT + Up", dsp.window.move({ workspace = "special", follow = false }))
bind("SUPER + ALT + S",           dsp.window.move({ workspace = "special", follow = false }))

bind("CTRL + SUPER + SHIFT + Right", dsp.window.move({ workspace = "+1", follow = true }))
bind("CTRL + SUPER + SHIFT + Left",  dsp.window.move({ workspace = "-1", follow = true }))
bind("CTRL + SUPER + Up",            dsp.focus({ workspace = "-5" }))
bind("CTRL + SUPER + Down",          dsp.focus({ workspace = "+5" }))
bind("SUPER + SHIFT + mouse_down",   dsp.window.move({ workspace = "-1", follow = true }))
bind("SUPER + SHIFT + mouse_up",     dsp.window.move({ workspace = "+1", follow = true }))

bind("SUPER + P", dsp.window.pin())

-------------------------
--- WINDOW MANAGEMENT ---
-------------------------

-- Focus / move in direction (arrows + hjkl)
local dirs = {
    { arrow = "Left",  vim = "h", dir = "left" },
    { arrow = "Right", vim = "l", dir = "right" },
    { arrow = "Up",    vim = "k", dir = "up" },
    { arrow = "Down",  vim = "j", dir = "down" },
}
for _, d in ipairs(dirs) do
    bind("SUPER + " .. d.arrow,         dsp.focus({ direction = d.dir }))
    bind("SUPER + " .. d.vim,           dsp.focus({ direction = d.dir }))
    bind("SUPER + SHIFT + " .. d.arrow, dsp.window.move({ direction = d.dir }))
    bind("SUPER + SHIFT + " .. d.vim,   dsp.window.move({ direction = d.dir }))
end

bind("SUPER + Tab",       dsp.window.cycle_next())
bind("SUPER + mouse:272", dsp.window.drag(),   { mouse = true })
bind("SUPER + mouse:273", dsp.window.resize(), { mouse = true })
bind("SUPER + Q",         dsp.window.close())
bind("SUPER + SHIFT + ALT + Q", exec("hyprctl kill"), { description = "Pick and kill a window" })

-- Window split ratio
bind("SUPER + Minus",      dsp.layout("splitratio -0.1"), repeating)
-- bind("SUPER + Period",  dsp.layout("splitratio +0.1"), repeating)
bind("SUPER + Semicolon",  dsp.layout("splitratio -0.1"), repeating)
bind("SUPER + Apostrophe", dsp.layout("splitratio +0.1"), repeating)

-- Positioning mode
bind("SUPER + ALT + Space", dsp.window.float({ action = "toggle" }))
bind("SUPER + ALT + F",     dsp.window.fullscreen_state({ internal = 0, client = 3 }), { description = "Toggle fake fullscreen" })
bind("SUPER + F",           dsp.window.fullscreen({ mode = "fullscreen" }))
bind("SUPER + D",           dsp.window.fullscreen({ mode = "maximized" }))

------------------
--- BRIGHTNESS ---
------------------

bind("XF86MonBrightnessUp",   exec("brightnessctl set 5%+"), lockrep)
bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), lockrep)

-------------
--- MEDIA ---
-------------

bind("XF86AudioMicMute",     exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),      lockrep)
bind("XF86AudioMute",        exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),        lockrep)
bind("XF86AudioRaiseVolume", exec("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),  lockrep)
bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),         lockrep)

bind("SUPER + SHIFT + N",               exec(next_track), { locked = true, description = "Next track" })
bind("XF86AudioNext",                   exec(next_track), locked)
bind("XF86AudioPrev",                   exec("playerctl previous"), locked)
bind("SUPER + SHIFT + ALT + mouse:275", exec("playerctl previous"))
bind("SUPER + SHIFT + ALT + mouse:276", exec(next_track))
bind("SUPER + SHIFT + B",               exec("playerctl previous"),   { locked = true, description = "Previous track" })
bind("SUPER + SHIFT + P",               exec("playerctl play-pause"), { locked = true, description = "Play/pause media" })
bind("XF86AudioPlay",                   exec("playerctl play-pause"), locked)
bind("XF86AudioPause",                  exec("playerctl play-pause"), locked)

------------------------------
--- BARS AND WIDGETS (ags) ---
------------------------------

bind("CTRL + SUPER + R",       exec("systemctl --user restart ags"), release)
bind("CTRL + SUPER + ALT + R", exec("hyprctl reload; ags quit; ags run"), release)
bind("SUPER + N",              exec("ags request dashboard"))
bind("SUPER + O",              exec("ags request quicksettings"))

---------------
--- TESTING ---
---------------

bind("SUPER + ALT + F12", exec([[fyi -a 'Shell' -A "Test1:I got it!" -A "Test2:Another action" -t 5000 'Test notification' "Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!"]]))
bind("SUPER + ALT + F11", exec([[fyi -u critical -a 'Hyprland keybind' "Urgent notification" "Ah hell no"]]))

------------
--- APPS ---
------------

bind("SUPER + E",                exec("nautilus --new-window"), { description = "Launch Nautilus (file manager)" })
bind("CTRL + SUPER + V",         exec("pavucontrol"),           { description = "Launch pavucontrol (volume mixer)" })
bind("CTRL + SUPER + SHIFT + V", exec("easyeffects"),           { description = "Launch EasyEffects (equalizer & other audio effects)" })
bind("CTRL + SUPER + Minus",     dsp.window.resize({ x = 640, y = 480 }))
