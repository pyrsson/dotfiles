-- General config
-- Every variable: https://wiki.hypr.land/Configuring/Basics/Variables/

-- Laptop touchpad: adaptive accel (global input uses flat)
hl.device({
  name = "elan0673:00-04f3:3188-touchpad",
  accel_profile = "adaptive",
})

-- monitors

-- Per-host monitors, linked from hosts/<env>/hypr/monitors.lua (hosts/default/ otherwise)
require("hyprland.monitors")
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- config

hl.config({
  binds = {
    scroll_event_delay = 150, -- rate-limit wheel binds
    movefocus_cycles_fullscreen = true,
  },

  input = {
    kb_layout = "se",
    kb_variant = "nodeadkeys",
    kb_options = "caps:escape",

    accel_profile = "flat",
    sensitivity = 0.4,
    follow_mouse = 1,

    repeat_delay = 230,
    repeat_rate = 30,

    touchpad = {
      disable_while_typing = false,
      scroll_factor = 0.5,
    },
  },

  cursor = {
    persistent_warps = true,
  },

  gestures = {
    workspace_swipe_distance = 700,
    workspace_swipe_cancel_ratio = 0.2,
    workspace_swipe_min_speed_to_force = 5,
    workspace_swipe_direction_lock = true,
    workspace_swipe_direction_lock_threshold = 10,
    workspace_swipe_create_new = true,
  },

  general = {
    gaps_in = 4,
    gaps_out = 8,
    gaps_workspaces = 30,
    border_size = 3,

    col = {
      active_border = "rgba(8dd5b2aa)", -- { colors = { "rgba(82aaffaa)", "rgba(4fd6beaa)" }, angle = 200 },
      inactive_border = "rgba(303632aa)",
    },

    resize_on_border = true,
    no_focus_fallback = true,

    layout = "dwindle",

    allow_tearing = true, -- This just allows the `immediate` window rule to work
  },

  dwindle = {
    preserve_split = true,
    smart_split = false,
    smart_resizing = false,
    force_split = 2,
    split_width_multiplier = 1.5,
  },

  decoration = {
    rounding = 8,

    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      xray = false,
    },

    shadow = {
      enabled = false,
    },
  },

  animations = {
    enabled = true,
  },

  misc = {
    vrr = 1,
    animate_manual_resizes = false,
    animate_mouse_windowdragging = false,
    enable_swallow = false,
    swallow_regex = "(foot|kitty|alacritty|Alacritty)",

    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
    on_focus_under_fullscreen = 2, -- was new_window_takes_over_fullscreen
    allow_session_lock_restore = true,

    initial_workspace_tracking = false,
    background_color = "rgba(131318FF)",
    focus_on_activate = true,
  },
})

-- animations

local function bezier(name, x0, y0, x1, y1)
  hl.curve(name, { type = "bezier", points = { { x0, y0 }, { x1, y1 } } })
end

bezier("linear", 0, 0, 1, 1)
bezier("md3_standard", 0.2, 0, 0, 1)
bezier("md3_decel", 0.05, 0.7, 0.1, 1)
bezier("md3_accel", 0.3, 0, 0.8, 0.15)
bezier("overshot", 0.05, 0.9, 0.1, 1.1)
bezier("crazyshot", 0.1, 1.5, 0.76, 0.92)
bezier("hyprnostretch", 0.05, 0.9, 0.1, 1.0)
bezier("menu_decel", 0.1, 1, 0, 1)
bezier("menu_accel", 0.38, 0.04, 1, 0.07)
bezier("easeInOutCirc", 0.85, 0, 0.15, 1)
bezier("easeOutCirc", 0, 0.55, 0.45, 1)
bezier("easeOutExpo", 0.16, 1, 0.3, 1)
bezier("softAcDecel", 0.26, 0.26, 0.15, 1)
bezier("md2", 0.4, 0, 0.2, 1) -- use with .2s duration
bezier("easeOutQuint", 0.23, 1, 0.32, 1)

local function anim(leaf, speed, curve, style)
  hl.animation({ leaf = leaf, enabled = true, speed = speed, bezier = curve, style = style })
end

anim("windows", 3, "md3_decel", "popin 60%")
anim("windowsIn", 3, "md3_decel", "popin 60%")
anim("windowsOut", 3, "md3_accel", "popin 60%")
anim("border", 10, "default")
anim("borderangle", 14, "easeOutExpo")
anim("fade", 3, "md3_decel")
-- anim("layers",        2,   "md3_decel",   "slide")
anim("layersIn", 3, "menu_decel", "slide")
anim("layersOut", 1.6, "menu_accel")
anim("fadeLayersIn", 2, "menu_decel")
anim("fadeLayersOut", 2, "menu_accel")
if require("hyprland.host").tagger then
  -- combined tag views assemble off-screen, then slide in
  anim("workspaces", 3, "easeOutQuint", "slidefade 20%")
  anim("windowsMove", 3, "easeOutQuint")
else
  anim("workspaces", 7, "menu_decel", "slide")
end
-- anim("workspaces",    2.5, "softAcDecel", "slide")
-- anim("workspaces",    7,   "menu_decel",  "slidefade 15%")
anim("specialWorkspace", 3, "md3_decel", "slidefadevert 15%")
-- anim("specialWorkspace", 3, "md3_decel",  "slidevert")
