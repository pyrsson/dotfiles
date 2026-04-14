if command -q kubecolor
    alias kubectl=kubecolor
    function k -d "kubecolor alias" --wraps kubecolor
        kubecolor $argv
    end
end
