## For my future self when I am gonna be using this on a fresh Mac

I managed to get the flake to state when in installs some basic stuff.

Clone this repository to `~/.dotfiles`, then use the scripts in this directory
to install Homebrew and Nix. On a fresh Apple Silicon Mac, install nix-darwin
and apply the configuration with:

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin/master#darwin-rebuild -- switch --flake ~/.dotfiles/nix#default --impure
```

The flake uses `SUDO_USER` when running through sudo, otherwise `USER`, and
sets the home directory to `/Users/<username>`. Keep `--impure`: it allows Nix
to read these environment variables. Run the command from your normal user
account, not a root login shell.

For subsequent rebuilds, use the installed tool instead of downloading it again:

```sh
sudo /run/current-system/sw/bin/darwin-rebuild switch --flake ~/.dotfiles/nix#default --impure
```

After the shell configuration is loaded, `nixrebuild` runs that same command.

after that download my ansible repo and use it to setup ssh keys.

Will need to install kanata. First just try `cargo install kanata --version 1.6.1` and see if it's gonna work.
if not then try installing karabiner driver. see the kmonad file my ansible repo. it has it there automated.
