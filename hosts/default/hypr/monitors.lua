-- Monitors and workspace placement for hosts without their own file
-- Linked to ~/.config/hypr/hyprland/monitors.lua by mise.toml; mise.<env>.toml overrides the link.
-- Every output falls through to the catch-all rule in general.lua.

return {
  -- workspace -> { monitor, default-for-monitor? }
  workspaces = {},
  -- workspace -> scrolling layout direction
  scrolling = {},
}
