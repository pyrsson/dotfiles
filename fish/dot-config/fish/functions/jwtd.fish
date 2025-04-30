function jwtd -d "Decode a JWT token" -a token
    if test (count $argv) -eq 0
        while read -l line
            jwtd $line
        end
        return
    end
    echo $token | jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
end
