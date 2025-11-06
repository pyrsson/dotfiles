function autoreload --on-event fish_prompt -d 'auto source config.fish if gets modified!'
    set -l fish_config_paths ~/.config/fish/conf.d/*.fish ~/.config/fish/config.fish

    set -q FISH_CONFIG_TIME
    if test $status -ne 0
        set -g FISH_CONFIG_TIME (echo $fish_config_paths | xargs -n1 date +%s -r | sort -n | head -1)
    else
        set FISH_CONFIG_TIME_NEW (echo $fish_config_paths | xargs -n1 date +%s -r | sort -n | head -1)
        if test "$FISH_CONFIG_TIME" != "$FISH_CONFIG_TIME_NEW"
            for f in $fish_config_paths
                source $f
            end
            set FISH_CONFIG_TIME $FISH_CONFIG_TIME_NEW
        end
    end
end
