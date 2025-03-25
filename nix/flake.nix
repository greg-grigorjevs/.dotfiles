{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-latest.url = "github:NixOS/nixpkgs/a84ebe20c6bc2ecbcfb000a50776219f48d134cc";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixpkgs-stable, nixpkgs-latest }:
    let
      user = builtins.getEnv "USER";
      system = "aarch64-darwin";

      overlays = [
        (final: prev: {
          latest = import nixpkgs-latest {
            system = prev.system;
            config.allowUnfree = true;
          };

          stable = import nixpkgs-stable {
            system = prev.system;
            config.allowUnfree = true;
          };
        })
      ];

      configuration = { pkgs, ... }: rec {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages =
          [
          ];

        security.sudo.extraConfig = ''
          ${user} ALL=(ALL) NOPASSWD: ${pkgs.latest.kanata}/bin/kanata, \
          /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager
        '';
        nixpkgs.overlays = overlays;

        fonts.packages = [ pkgs.nerd-fonts.sauce-code-pro ];
        ids.gids.nixbld = 350;


        system.keyboard = {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        };

        nix.settings.experimental-features = "nix-command flakes";
        programs.zsh = {
          enable = true; # default shell on catalina
        };
        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 4;
        nixpkgs.hostPlatform = "aarch64-darwin";

        security.pam.services.sudo_local = {
          enable = true;
          reattach = true;
          touchIdAuth = true;
          watchIdAuth = true;
        };

        users.users.${user}.home = "/Users/${user}";
        home-manager.backupFileExtension = "backup";
        # nix.configureBuildUsers = true;

        system.defaults = {
          dock = {
            autohide = true;
            autohide-delay = 0.0;
            mru-spaces = false;
            magnification = true;
            largesize = 86;
            scroll-to-open = true;
          };
          finder = {
            AppleShowAllExtensions = true;
            FXPreferredViewStyle = "Nlsv";
            AppleShowAllFiles = true;
            ShowPathbar = true;
          };
          magicmouse.MouseButtonMode = "TwoButton";
          screencapture.location = "~/Desktop/screenshots";
          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
            AppleScrollerPagingBehavior = true;
            InitialKeyRepeat = 10;
            KeyRepeat = 10;
            NSAutomaticSpellingCorrectionEnabled = false;
          };
          controlcenter = {
            BatteryShowPercentage = true;
            Bluetooth = true;
            Sound = true;
          };
          # screensaver.askForPasswordDelay = 10;
        };

        # Configure launchd to manage the Karabiner daemon from the nix store
        launchd.daemons.karabiner-daemon = {
          serviceConfig = {
            Program = "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
            KeepAlive = true;
            RunAtLoad = true;
          };
        };

        system.activationScripts.postActivation.text = ''
          # Activate Karabiner VirtualHIDDevice
          sudo /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate || true
        '';

        # Homebrew needs to be installed on its own!
        homebrew.enable = true;
        homebrew.casks = [
          "kitty"
          "hammerspoon"
          "monitorcontrol"
          "insomnia"
          # "docker"
          "obsidian"
          "google-chrome"
          "raycast"
          "vlc"
          "transmission"
          "appcleaner"
          "karabiner-elements"
          "microsoft-teams"
          "microsoft-outlook"
        ];

        homebrew.brews = [
          "php"
          "composer"
        ];

        homebrew.masApps = {
          "Amphetamine" = 937984704; # App Store ID for Amphetamine
        };
      };

      home-config = { config, lib, pkgs, stable-pkgs, unstable-pkgs, pkgs-latest, ... }:
        let
          inherit (config.lib.file) mkOutOfStoreSymlink;
        in
        {
          home.username = user;
          home.homeDirectory = nixpkgs.lib.mkForce "/Users/${user}";
          home.stateVersion = "24.05"; # Please read the comment before changing.

          # Makes sense for user specific applications that shouldn't be available system-wide
          home.packages = with pkgs; [
            ansible
            atac
            neovim
            ripgrep
            lazygit
            tmux
            nodePackages.prettier
            prettierd
            starship
            nodejs_23
            yarn
            fd
            fzf
            gcc
            cargo
            tree
            yazi
            btop
            git
            latest.kanata
          ];

          # Home Manager is pretty good at managing dotfiles. The primary way to manage
          # plain files is through 'home.file'.
          home.file = {
            ".zshrc".source = mkOutOfStoreSymlink ~/.dotfiles/zsh/.zshrc;
            ".config/lazygit".source = mkOutOfStoreSymlink ~/.dotfiles/lazygit/.config/lazygit;
            ".config/starship.toml".source = mkOutOfStoreSymlink ~/.dotfiles/starship/.config/starship.toml;
            ".hammerspoon".source = mkOutOfStoreSymlink ~/.dotfiles/hammerspoon/.hammerspoon;
            ".config/nvim".source = mkOutOfStoreSymlink ~/.dotfiles/nvim/.config/nvim;
            ".config/kitty".source = mkOutOfStoreSymlink ../kitty/.config/kitty;
            ".tmux.conf".source = mkOutOfStoreSymlink ~/.dotfiles/tmux/.tmux.conf;
            ".local/bin".source = mkOutOfStoreSymlink ~/.dotfiles/scripts/.local/bin;
          };

          # Add an activation script to create the screenshots folder
          home.activation = {
            createScreenshotsFolder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              $DRY_RUN_CMD mkdir -p $HOME/Desktop/screenshots
            '';

            setupGitRepos = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              mkdir -p $HOME/dev
              mygithub="https://github.com/greg-grigorjevs/"
              git="${pkgs.git}/bin/git"

              $git -C $HOME/.dotfiles config user.name "Greg Grigorjevs"
              $git -C $HOME/.dotfiles config user.email "ggrigorjevs@icloud.com"
              $git -C $HOME/.dotfiles remote set-url origin git@github.com:greg-grigorjevs/.dotfiles.git

              if [ ! -d $HOME/ansible ]; then
                $git clone $mygithub/ansible $HOME/ansible
                $git -C $HOME/ansible config user.name "Greg Grigorjevs"
                $git -C $HOME/ansible config user.email "ggrigorjevs@icloud.com"
              fi
            '';
          };

          home.sessionVariables = { };

          home.sessionPath = [
          ];
          programs.home-manager.enable = true;

          programs.fzf.enable = true;
          programs.fzf.enableZshIntegration = true;

          programs.zsh = {
            enable = true;
            dotDir = ".config/nixzsh";
            syntaxHighlighting.enable = true;
            initExtra = ''
              source ~/.zshrc
            '';
          };

          programs.git = {
            enable = true;
            userEmail = "gregg@coeouk.com";
            userName = "Greg Grigorjevs";
            extraConfig = {
              pull.rebase = true;
              core.excludesfile = "~/.config/git/.gitignore";
              rebase.autostash = true;
            };
          };

          programs.starship = {
            enable = true;
          };
        };
    in
    {
      darwinConfigurations."default" = nix-darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
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
      darwinPackages = self.darwinConfigurations."default".pkgs;
    };
}
