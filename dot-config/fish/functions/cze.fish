function cze --description 'edit dotfiles repo'
    set -l prev_dir (pwd)
    cd ~/Projects/personal/dotfiles
    nvim
    cd $prev_dir
end
