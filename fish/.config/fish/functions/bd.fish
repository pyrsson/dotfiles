function bd -d "Base64 decode a string" -a input
    echo $input | base64 -di
end

function be -d "Base64 encode a string" -a input
    echo $input | base64
end
