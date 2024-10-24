{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixpkgs-stable }:
    let
      user = "gregg";
      host = "CRS-MAC-01";
      stable-pkgs = import nixpkgs-stable { system = "aarch64-darwin"; config.allowBroken = false; };
      #stable-pkgs = nixpkgs-stable.legacyPackages."aarch64-darwin";
      configuration = { pkgs, ... }: rec {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages =
          [
          ];

        fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; }) ];

        system.keyboard = {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        };

        services.nix-daemon.enable = true;
        nix.settings.experimental-features = "nix-command flakes";
        programs.zsh = {
          enable = true; # default shell on catalina
          enableCompletion = false; # fixed compinit warnings on mac m1 pro
        };
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 4;
        nixpkgs.hostPlatform = "aarch64-darwin";
        security.pam.enableSudoTouchIdAuth = true;

        users.users.${user}.home = "/Users/${user}";
        home-manager.backupFileExtension = "backup";
        nix.configureBuildUsers = true;
        nix.useDaemon = true;

        system.defaults = {
          dock.autohide = true;
          dock.autohide-delay = 0.0;
          dock.mru-spaces = false;
          finder.AppleShowAllExtensions = true;
          finder.FXPreferredViewStyle = "Nlsv";
          screencapture.location = "~/Desktop/screenshots";
          # screensaver.askForPasswordDelay = 10;
        };


        # Homebrew needs to be installed on its own!
        homebrew.enable = true;
        homebrew.casks = [
          "kitty"
          "hammerspoon"
          "obsidian"
          "google-chrome"
          # "raycast"
          # "vlc"
          # "transmission"
          # "appcleaner"
        ];
        homebrew.brews = [
        ];
      };
      home-config = { config, lib, pkgs, stable-pkgs, ... }:
        {
          home.username = user;
          home.homeDirectory = nixpkgs.lib.mkForce "/Users/${user}";
          home.stateVersion = "24.05"; # Please read the comment before changing.
          # home.activation.installKanata = lib.hm.dag.entryAfter [ "installPackages" ] ''
          #   echo "installig Kanata"
          #   export PATH="$HOME/.nix-profile/bin:$PATH"
          #   cargo install kanata --version=1.6.1 --force
          # '';


          # Makes sense for user specific applications that shouldn't be available system-wide
          home.packages = with pkgs; [
            ansible
            neovim
            #kmonad
            ripgrep
            lazygit
            tmux
            nodePackages.prettier
            prettierd
            starship
            yarn
            fd
            fzf
            gcc
            cargo
            tree
            yazi
            #composer
            git
            #stable-pkgs.kanata
          ];


          # Home Manager is pretty good at managing dotfiles. The primary way to manage
          # plain files is through 'home.file'.
          home.file = {
            ".zshrc".source = config.lib.file.mkOutOfStoreSymlink ~/.dotfiles/zsh/.zshrc;
            ".config/lazygit".source = config.lib.file.mkOutOfStoreSymlink ~/.dotfiles/lazygit/.config/lazygit;
            ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink ~/.dotfiles/starship/.config/starship.toml;
            ".hammerspoon".source = config.lib.file.mkOutOfStoreSymlink ~/.dotfiles/hammerspoon/.hammerspoon;
            # ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/zellij;
            ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ~/.dotfiles/nvim/.config/nvim;
            ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink ../kitty/.config/kitty;
            # ".config/nix".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/nix;
            # ".config/nix-darwin".source = config.lib.file.mkOutOfStoreSymlink ~/dotfiles/nix-darwin;
            ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink ~/.dotfiles/tmux/.tmux.conf;
          };

          home.sessionVariables = { };

          home.sessionPath = [
            "/run/current-system/sw/bin"
            "$HOME/.nix-profile/bin"
          ];
          #programs.neovim.enable = true;
          programs.home-manager.enable = true;
          #programs.nix-index.enable = true;
          
          #disable this whole thing altogether as it seeems that zsh is not getting configured properly
          # if I am symlinking my existing .zshrc
          #programs.fzf.enable = true;
          #programs.fzf.enableZshIntegration = true;
          programs.zsh = {
            enable = false;
            #dotDir = ".config/nixzsh";
            initExtra = ''
              # Add any additional configurations here
              export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
              if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
                . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
              fi

              #source ~/.zshrc
            '';
            enableCompletion = false;
          };
        };
    in
    {
      darwinConfigurations.${host} = nix-darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit stable-pkgs; };
            home-manager.useGlobalPkgs = true;
            # changing this to false fixed installed packages not available
            # why ? 
             home-manager.useUserPackages = false;
            home-manager.backupFileExtension = "backup";
            # home-manager.users.${user} = import ./home.nix;
            home-manager.users.${user} = home-config;
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.${host}.pkgs;
    };
}
