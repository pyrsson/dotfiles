command -q hyprctl; or return 0
function h -d "hyprctl alias" --wraps hyprctl
    hyprctl $argv
end
