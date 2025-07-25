function setup-extras -d 'setup extras'
    # standard style command completion
    for e in kustomize talosctl cue kcl hcp vcluster argocd kcp kubebuilder
        type -q $e && eval $e completion fish >$XDG_CONFIG_HOME/fish/completions/$e.fish
    end

    # direnv hook
    type -q direnv && direnv hook fish >$XDG_CONFIG_HOME/fish/conf.d/direnv.fish

    # non-standard style command completion
    type -q zellij && zellij setup --generate-completion fish >$XDG_CONFIG_HOME/fish/completions/zellij.fish
    type -q stern && stern --completion fish >$XDG_CONFIG_HOME/fish/completions/stern.fish
end
