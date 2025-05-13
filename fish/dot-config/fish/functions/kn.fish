command -q kubens; or return 0
function kn -d "kubens alias" --wraps kubens
    kubens $argv
end
