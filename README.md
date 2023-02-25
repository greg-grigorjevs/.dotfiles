# My dotfiles

## Some notes for later
### Some files like .zshrc or alacritty.yml are good for inital setup but needs to be tweaked a little for
different systems so after the initial setup do :
- ```git update-index --skip-worktree <filename>``` to stop tracking the file locally
- ```git update-index --no-skip-worktree <filename>``` to undo that
- ```git update-index --assume-unchanged <filename>``` to stop trancking the next change
- ```git ls-files -v | grep ^S``` to list all the locally untracked files
