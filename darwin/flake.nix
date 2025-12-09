{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.cl-nix-lite.url = "github:r4v3n6101/cl-nix-lite/url-fix";
    };
  };

  outputs = inputs@{ self, nix-darwin, mac-app-util, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      networking.hostName = "macbook";
      system.primaryUser = "reece";
 
      users.users.reece = {
        name = "reece";
        home = "/Users/reece";
      };     


      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
	        pkgs.devbox
	        pkgs.cmake
        ];

      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToControl = true;
      # system.keyboard.swapLeftCommandAndLeftAlt = true;

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.fira-code
        nerd-fonts.meslo-lg
      ];

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # ZSH
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        enableFastSyntaxHighlighting = true;
      };

      homebrew = {
          enable = true;
          onActivation = {
            cleanup = "zap";
            upgrade = true;
            autoUpdate = true;
          };
          taps = [
            "FelixKratz/formulae"
          ];
          casks = [
            "claude-code"
            "atuin-desktop"
            "alacritty"
          ];
          brews = [ 
            "atuin"
            "bat"
            "borders" 
            "git"
            "neovim"
            "pure"
            "ripgrep"
            "stow"
            "zellij"
          ];

      };

      system.defaults = {
          dock = {
              autohide = true;
              # persistent-apps = [
              # "${pkgs.alacritty}/Applications/Alacritty.app/"
              # ];
          };
      };

      services.aerospace = { 
          enable = true;
          settings = {
            config-version = 2;
            persistent-workspaces  = ["code" "browser" "mail"];
            # Disable cmd+h hide
            automatically-unhide-macos-hidden-apps = true;
            gaps = {
              outer.left = 8;
              outer.bottom = 8;
              outer.top = 8;
              outer.right = 8;
              inner.horizontal = 8;
              inner.vertical = 8;
            };
            mode.main.binding = {
              #
              # cmd-h = [];
              # cmd-h = "exec-and-forget zellij action move-focus left";

              # Layouts
              ctrl-cmd-slash = "layout tiles horizontal";
              ctrl-cmd-comma = "layout accordion horizontal";

              # Window focus
              ctrl-cmd-h = "focus left";
              ctrl-cmd-j = "focus down";
              ctrl-cmd-k = "focus up";
              ctrl-cmd-l = "focus right";

              # Window movement
              ctrl-cmd-shift-h = "move left";
              ctrl-cmd-shift-j = "move down";
              ctrl-cmd-shift-k = "move up";
              ctrl-cmd-shift-l = "move right";

              # Resize
              ctrl-cmd-equal = "resize smart +25";
              ctrl-cmd-minus = "resize smart -25";

              # Workspaces
              ctrl-cmd-n = "workspace x";
              ctrl-cmd-o = "workspace next";
              ctrl-cmd-i = "workspace prev";
              ctrl-cmd-shift-o = "move-node-to-workspace next --focus-follows-window";
              ctrl-cmd-shift-i = "move-node-to-workspace prev --focus-follows-window";

              ctrl-cmd-t = "exec-and-forget alacritty msg create-window";
            };
            after-startup-command = [
              "exec-and-forget borders active_color=0xFF52CBBD inactive_color=0xff494d64 width=8.0"
            ];
          };
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
        mac-app-util.darwinModules.default
      ];
    };
  };
}
