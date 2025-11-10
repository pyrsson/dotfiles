function setup-extras -d 'setup extras'
    # standard style command completion
    for e in kustomize talosctl cue kcl hcp vcluster argocd kcp kubebuilder tilt omnictl dms
        type -q $e && eval $e completion fish >$HOME/.config/fish/completions/$e.fish
    end

    # direnv hook
    type -q direnv && direnv hook fish >$HOME/.config/fish/conf.d/direnv.fish

    # non-standard style command completion
    type -q zellij && zellij setup --generate-completion fish >$HOME/.config/fish/completions/zellij.fish
    type -q stern && stern --completion fish >$HOME/.config/fish/completions/stern.fish
end
