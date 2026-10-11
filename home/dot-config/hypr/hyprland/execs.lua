-- Autostart
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
--
-- Apps (zen, ghostty, bitwarden, steam, vesktop) are started from ~/.config/autostart
-- by uwsm's XDG autostart (see mise/dotfiles.toml).
-- Cursor and toolkit env vars come from ~/.config/environment.d/common.conf.

-- Laptop touchpad: adaptive accel (global input uses flat)
hl.device({
  name = "elan0673:00-04f3:3188-touchpad",
  accel_profile = "adaptive",
})
