function kc -d "Switch between kubeconfig files"
    set -lx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --reverse --no-separator --info hidden --border rounded --ansi"

    set -l current_parts (readlink ~/.kube/config | string split /)
    set -l current $current_parts[-1]
    set -l desired_kubeconfigs $argv
    set -l green (printf '\033[32;1m')
    set -l reset (printf '\033[0m')

    if test (count $desired_kubeconfigs) -gt 0; and test "$desired_kubeconfigs[1]" = -d
        if test (count $desired_kubeconfigs) -ne 2
            echo "Usage: kc -d <kubeconfig>" >&2
            return 1
        end

        set -l delete_kubeconfig $desired_kubeconfigs[2]
        if not test -f ~/.kube/config.d/"$delete_kubeconfig"
            echo "Kubeconfig $delete_kubeconfig does not exist" >&2
            return 1
        end

        rm ~/.kube/config.d/"$delete_kubeconfig"; or return 1
        echo "Deleted $delete_kubeconfig"
        return 0
    end

    if test (count $desired_kubeconfigs) -eq 1; and test "$desired_kubeconfigs[1]" = -
        if not test -f ~/.kube/kc
            echo "No previous kubeconfig recorded" >&2
            return 1
        end

        set desired_kubeconfigs (string collect <~/.kube/kc)
    end

    if test (count $desired_kubeconfigs) -eq 0
        set desired_kubeconfigs (fd --base-directory ~/.kube/config.d/ | while read -l kubeconfig
            if test "$kubeconfig" = "$current"
                printf '%s%s%s\n' $green $kubeconfig $reset
            else
                printf '%s\n' $kubeconfig
            end
        end | fzf --multi --border none --separator "─")

        if test (count $desired_kubeconfigs) -eq 0
            return 1
        end
    end

    for kubeconfig in $desired_kubeconfigs
        if not test -f ~/.kube/config.d/"$kubeconfig"
            echo "Kubeconfig $kubeconfig does not exist" >&2
            return 1
        end
    end

    if test (count $desired_kubeconfigs) -gt 1
        set -gx KUBECONFIG (string join : ~/.kube/config.d/$desired_kubeconfigs)
        echo "Set KUBECONFIG to $KUBECONFIG"
        return 0
    end

    set -l desired_kubeconfig $desired_kubeconfigs[1]
    set -e KUBECONFIG

    if test "$desired_kubeconfig" != "$current"
        echo "$current" >~/.kube/kc
        rm -f ~/.kube/config
        ln -rs ~/.kube/config.d/"$desired_kubeconfig" ~/.kube/config; or return 1
        echo "Switched to $desired_kubeconfig"
    end
end
