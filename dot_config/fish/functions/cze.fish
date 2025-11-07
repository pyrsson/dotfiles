function cze --wraps "chezmoi edit"
    cd (chezmoi source-path)
    chezmoi edit --watch
end
