#!/bin/bash

# Download software
/bin/bash environment.sh


# Copied some files from https://github.com/JJGO/dotfiles/tree/master
PROGRAMS=(vim fish tmux)
OLD_DOTFILES="dotfile_bk_$(date -u +"%Y%m%d%H%M%S")"
mkdir -p "$OLD_DOTFILES"

function backup_if_exists() {
    if [ -e "$1" ]; then
        mv "$1" "$OLD_DOTFILES"
    fi
}

# Clean common conflicts
backup_if_exists ~/.config/vim
backup_if_exists ~/.config/nvim
backup_if_exists ~/.config/fish
backup_if_exists ~/.config/tmux

for program in "${PROGRAMS[@]}"; do
    mkdir -p "$HOME/.config/$program"
    stow -v --target="$HOME/.config/$program" "$program"
    echo "Configuring $program"
done

mkdir -p ~/.vim/undodir

# Install plugins for vim and nvim
mkdir -p ~/.config/nvim
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "set runtimepath^=~/.config/vim runtimepath+=~/.config/vim/after" > ~/.config/nvim/init.vim
echo "let &packpath = &runtimepath" >> ~/.config/nvim/init.vim
echo "source ~/.config/vim/.vimrc" >> ~/.config/nvim/init.vim
nvim -u ~/.config/vim/.vimrc --headless +PlugInstall +qall

echo "Done!"
