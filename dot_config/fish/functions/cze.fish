function cze --wraps "chezmoi edit"
    set -l prev_dir (pwd)
    cd (chezmoi source-path)
    nvim
    cd $prev_dir
end
