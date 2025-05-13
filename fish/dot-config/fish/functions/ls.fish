command -q eza; or return 0
function ls -d "eza alias" --wraps eza
    eza $argv
end
