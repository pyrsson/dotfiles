# kc

complete -c kc -e
complete -f -x -c kc -a '(find ~/.kube/config.d/* -printf "%f\n")'
