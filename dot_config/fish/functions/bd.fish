function bd -d "Base64 decode a string" -a input
    if test (count $argv) -eq 0
        while read -l line
            bd $line
        end
        return
    end
    echo -n $input | base64 -di
end

function be -d "Base64 encode a string" -a input
    if test (count $argv) -eq 0
        while read -l line
            be $line
        end
        return
    end
    echo -n $input | base64
end
