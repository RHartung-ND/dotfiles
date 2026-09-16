#!/bin/bash
# Copied some files from https://github.com/JJGO/dotfiles/tree/master
PROGRAMS=(vim)
OLD_DOTFILES="dotfile_bk_$(date -u +"%Y%m%d%H%M%S")"
mkdir -p "$OLD_DOTFILES"

function backup_if_exists() {
    if [ -e "$1" ]; then
        mv "$1" "$OLD_DOTFILES"
    fi
}

# Clean common conflicts
backup_if_exists ~/.vim

for program in "${PROGRAMS[@]}"; do
    stow -v --target="$HOME" "$program"
    echo "Configuring $program"
done

mkdir -p ~/.vim/undodir

echo "Done!"
