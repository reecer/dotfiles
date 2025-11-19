{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "reece";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/reece" else "/home/reece";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Common packages
    pkgs.git
    pkgs.neovim
    pkgs.bat
    pkgs.zellij
    # pkgs.ghostty
  ] ++ (lib.optionals pkgs.stdenv.isLinux [
    # Linux-specific packages
    pkgs.pavucontrol
    pkgs.networkmanager
    pkgs.networkmanagerapplet
    pkgs.networkmanager-openvpn
    pkgs.inotify-tools
    pkgs.cameractrls
    pkgs.cliphist
    pkgs.blueman # replace with overskride flatpak
    pkgs.swww
    pkgs.waypaper
    pkgs.sunsetr
  ]) ++ (lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific packages (add any if needed)
  ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/reece/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Vi Mode
  # programs.broot.settings.modal = true;
  programs.zsh.setOptions = [ "VI" ];

  programs.atuin = {
    enable = true;
  };
  # ZSH
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;

    initExtra = ''
      # Initialize Devbox global shellenv
      eval "$(devbox global shellenv)"
    '';

    shellAliases = {
      ll = "ls -l";
      ls = "ls --color=auto";
      doy = "date -u +%j";
      gpsweek = "echo \"$((($(date +%s) - 315964800) / 604800 ))\"";
      k = "kubectl";
      d = "devbox";
      ds = "devbox shell";
      # winboot = "sudo efibootmgr -n 2 && systemctl reboot"
    } // (lib.optionalAttrs pkgs.stdenv.isLinux {
      docker = "/usr/sbin/podman";
    });

    sessionVariables = lib.optionalAttrs pkgs.stdenv.isLinux {
      DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
    };

    zplug = {
      enable = true;
      plugins = [
        # Autocompletion
        { name = "zsh-users/zsh-autosuggestions"; }
        # Pure
        { name = "mafredri/zsh-async"; }
        { name = "sindresorhus/pure"; tags=[use:pure.zsh as:theme]; }
      ];
    };
  };
}
