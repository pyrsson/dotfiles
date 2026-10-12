command -q zellij; or return 1

function z --wraps zellij --description "Run zellij"
    zellij $argv
end
