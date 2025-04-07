# kc

function __fish_kc_arg_number -a number
    set -l cmd (commandline -opc)
    test (count $cmd) -eq $number
end

complete -f -c kc
complete -f -x -c kc -n '__fish_kc_arg_number 1' -a "(fd --base-directory ~/.kube/config.d/)"
