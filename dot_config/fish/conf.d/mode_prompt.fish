function fish_mode_prompt
    switch $fish_bind_mode
        case default
            set_color --bold blue
            echo N
        case insert
            set_color --bold $fish_color_command
            echo I
        case replace_one
            set_color --bold green
            echo R
        case replace
            set_color --bold bryellow
            echo R
        case visual
            set_color --bold brmagenta
            echo V
        case '*'
            set_color --bold red
            echo ' ? '
    end
    set_color normal
    echo -n " "
end
