# kc

function __kc_config_files
    find ~/.kube/config.d/* -printf "%f\n"
end

function __kc_no_flags
    set -l tokens (commandline -opc)
    not contains -- - $tokens; and not contains -- -d $tokens
end

function __kc_delete_arg
    set -l tokens (commandline -opc)
    test (count $tokens) -eq 2; and test "$tokens[2]" = -d
end

complete -c kc -e
complete -f -c kc
complete -n __kc_no_flags -c kc -a '(__kc_config_files)' -d "File in ~/.kube/config.d/"
complete -n __fish_is_first_arg -c kc -a \- -d "Switch to previous kubeconfig"
complete -n __fish_is_first_arg -c kc -a \-d -d "Delete kubeconfig"
complete -n __kc_delete_arg -c kc -a '(__kc_config_files)' -d "File in ~/.kube/config.d/"
