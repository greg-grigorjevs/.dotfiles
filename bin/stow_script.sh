#!/usr/bin/env zsh
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="stow,nvim,tmux,scripts,kitty,fzf,lazygit,zsh,karabiner,mackup,starship"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
fi

pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    echo "stow $folder"
    # stow -D $folder
    # stow $folder

    # this should merge the existing dotfiles (if they exist) with the ones in the .dotfiles folder
    # then the difference between them can be checked with git diff and just resetted with git reset
    # if there is nothing important
    stow --adopt $folder
    stow --restow $folder # not sure if this is needed after stow --adopt 
done
popd

