if command -q kubectl
    function k -d "kubectl alias" --wraps kubectl
        kubectl $argv
    end
    if command -q kubecolor
        function k -d "kubecolor alias" --wraps kubecolor
            kubecolor $argv
        end
    end
end
