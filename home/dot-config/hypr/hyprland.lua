-- Hyprland Lua config
-- https://wiki.hypr.land/Configuring/Start/
-- API stubs (for lua-language-server): /usr/share/hypr/stubs/hl.meta.lua

local host = require("hyprland.host")

-- Must load before any window rule using its `tags` effect
if host.tagger then
  hl.plugin.load("/home/simon/Projects/personal/hyprtagger/hyprtagger.so")
end

require("hyprland.general")
-- After general: hyprtagger sets general.layout = "lua:mtile"
if host.tagger then
  require("hyprtagger").setup({ mfact = 0.5 })
end
require("hyprland.rules")
require("hyprland.keybinds")
