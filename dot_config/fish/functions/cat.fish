command -q bat; or return 0
function cat -d "bat alias" --wraps bat
    bat $argv
end
