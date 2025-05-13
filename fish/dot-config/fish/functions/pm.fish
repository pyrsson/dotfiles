command -q podman; or return 0
function pm -d "podman alias" --wraps podman
    podman $argv
end
