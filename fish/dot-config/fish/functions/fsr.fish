function fsr -d "reload fish config"
    for f in ~/.config/fish/conf.d/*.fish
        source $f
    end
    source ~/.config/fish/config.fish
end
