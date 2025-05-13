command -q kubectx; or return 0
function kx -d "kubectx alias" --wraps kubectx
    kubectx $argv
end
