function setup-extras -d 'setup extras'
    type -q kustomize && kustomize completion fish >$XDG_CONFIG_HOME/fish/completions/kustomize.fish
    type -q talosctl && talosctl completion fish >$XDG_CONFIG_HOME/fish/completions/talosctl.fish
    type -q stern && stern --completion fish >$XDG_CONFIG_HOME/fish/completions/stern.fish
    type -q cue && cue completion fish >$XDG_CONFIG_HOME/fish/completions/cue.fish
    type -q kcl && kcl completion fish >$XDG_CONFIG_HOME/fish/completions/kcl.fish
    type -q hcp && hcp completion fish >$XDG_CONFIG_HOME/fish/completions/hcp.fish
    type -q zellij && zellij setup --generate-completion fish >$XDG_CONFIG_HOME/fish/completions/zellij.fish
    type -q vcluster && vcluster completion fish >$XDG_CONFIG_HOME/fish/completions/vcluster.fish
    type -q argocd && argocd completion fish >$XDG_CONFIG_HOME/fish/completions/argocd.fish
    type -q direnv && direnv hook fish >$XDG_CONFIG_HOME/fish/conf.d/direnv.fish
    type -q kcp && kcp completion fish >$XDG_CONFIG_HOME/fish/completions/kcp.fish
end
