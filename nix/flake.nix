{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
        user = "gregg";
        #host = "CRS-MAC-01.local";
      configuration = { pkgs, ... }: rec {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        # environment.systemPackages =
        #   [ 
        #     pkgs.vim
        #     pkgs.direnv
        #     pkgs.age
        #     pkgs.sshs
        #     pkgs.atac
        #     pkgs.termshark
        #     pkgs.portal
        #     pkgs.glow
        #   ];
        services.nix-daemon.enable = true;
        nix.settings.experimental-features = "nix-command flakes";
        programs.zsh.enable = true; # default shell on catalina
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 4;
        nixpkgs.hostPlatform = "aarch64-darwin";
        security.pam.enableSudoTouchIdAuth = true;

        users.users.omerxx.home = "/Users/${user}";
        home-manager.backupFileExtension = "backup";
        nix.configureBuildUsers = true;
        nix.useDaemon = true;

        system.defaults = {
          dock.autohide = true;
          dock.mru-spaces = false;
          finder.AppleShowAllExtensions = true;
          finder.FXPreferredViewStyle = "clmv";
          screencapture.location = "~/Desktop/screenshots";
          # screensaver.askForPasswordDelay = 10;
        };


        # Homebrew needs to be installed on its own!
        homebrew.enable = true;
        homebrew.casks = [
          "hammerspoon"
          "raycast"
          "amphetamine"
          "kitty"
          "hammerspoon"
          "obsidian"
          "vlc"
          "transmission"
          "appcleaner"
        ];
        homebrew.brews = [
        ];
      };
        home-config = { config, pkgs, ... }: {
          home.username = user;
          home.homeDirectory = nixpkgs.lib.mkForce "/Users/${user}";
          home.stateVersion = "23.05"; # Please read the comment before changing.

          # Makes sense for user specific applications that shouldn't be available system-wide
          home.packages = with pkgs; [
            neovim
            ripgrep
            fd
            fzf
            #composer
            git
          ];

          # Home Manager is pretty good at managing dotfiles. The primary way to manage
          # plain files is through 'home.file'.
          home.file = {
            ".zshrc".source = /Users/gregg/.dotfiles/zsh/.zshrc;
            # ".zshrc".source = ~/dotfiles/zshrc/.zshrc;
            # ".config/wezterm".source = ~/dotfiles/wezterm;
            # ".config/skhd".source = ~/dotfiles/skhd;
            # ".config/starship".source = ~/dotfiles/starship;
            # ".config/zellij".source = ~/dotfiles/zellij;
            # ".config/nvim".source = ~/dotfiles/nvim;
            # ".config/nix".source = ~/dotfiles/nix;
            # ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
            # ".config/tmux".source = ~/dotfiles/tmux;
          };

          home.sessionVariables = { };

          home.sessionPath = [
            "/run/current-system/sw/bin"
            "$HOME/.nix-profile/bin"
          ];
          programs.home-manager.enable = true;
          programs.zsh = {
            enable = true;
            initExtra = ''
              # Add any additional configurations here
              export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
              if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
                . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
              fi
            '';
          };
        };
    in
    {
      darwinConfigurations."Grigorijss-MacBook-Pro-2" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # home-manager.users.${user} = import ./home.nix;
            home-manager.users.gregg = home-config;
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Grigorijss-MacBook-Pro-2".pkgs;
    };
}
