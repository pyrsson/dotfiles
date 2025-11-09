function cze --wraps "chezmoi edit"
    set -l prev_dir (pwd)
    cd (chezmoi source-path)
    chezmoi edit --watch
    cd $prev_dir
end
