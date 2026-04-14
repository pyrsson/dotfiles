# kc

complete -c kc -e
complete -f -c kc
complete -n __fish_is_first_arg -c kc -a '(find ~/.kube/config.d/* -printf "%f\n")' -d "File in ~/.kube/config.d/"
complete -n __fish_is_first_arg -c kc -a \- -d "Switch to previous kubeconfig"
