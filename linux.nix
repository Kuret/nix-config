{ config, pkgs, lib, newmpkg, ... }:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  newmpkg = (import flake-compat { src = builtins.fetchTarball "https://github.com/jbuchermn/newm/archive/master.tar.gz"; }).defaultNix;
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in {
  imports = [
    (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz}/nixos")
    "${nix-gaming}/modules/pipewireLowLatency.nix"
    ./common.nix
  ];

  # Use config from dotfiles
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/home/rick/dotfiles/hosts/${config.networking.hostName}/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];


  # Increase max file watches
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches"   = 1048576;   # default:  8192
    "fs.inotify.max_user_instances" =    1024;   # default:   128
    "fs.inotify.max_queued_events"  =   32768;   # default: 16384
  };

  environment.systemPackages = with pkgs; [
    (writeScriptBin "sudo" ''exec doas "$@"'') 	# Wrapper script to link 'sudo' to 'doas'
    (writeScriptBin "dmenu" ''exec rofi "$@"'') 	# Wrapper script to link 'dmenu' to 'rofi'

    brave         # Browser
    cider         # Apple Music
    wl-clipboard  # Utilities

    # WM Utils
    latte-dock

    swaylock-effects
    waybar
    mako
    libnotify
    grim slurp
    wob
    pulseaudio
    brightnessctl
    pavucontrol

    rofi-wayland
    rofi-bluetooth
    rofi-power-menu
    rofi-pulse-select
    networkmanager_dmenu
  ];

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.users.rick = import ./home/home-linux.nix;

  # Enable doas
  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
    users = [ "rick" ];
    keepEnv = true;
    noPass = true;
  }];

  users.users.rick = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" "video" ];
  };

  # GUI
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    # videoDrivers = [ "modesetting" ];

    displayManager.sddm.enable = true;
    displayManager.sessionCommands = ''
      dconf write /org/gnome/desktop/peripherals/touchpad/natural-scroll true
    '';

    desktopManager.plasma5.enable = true;
    desktopManager.plasma5.useQtScaling = true;
  };

  # Steam
  programs.steam.enable = true;

  # 1Password
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "rick" ];

  # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
  };

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # # Input
  # services.xserver.layout = "us";
  # services.xserver.xkbVariant = "";
  services.xserver.libinput.enable = true; # Enabled by default on most DE's
  services.xserver.libinput.touchpad.naturalScrolling = true;
  services.touchegg.enable = true;

  #
  # # Enable CUPS to print documents.
  # services.printing.enable = true;
  #
  # # ScreenShare on wlroots
  # xdg = {
  #   portal = {
  #     enable = true;
  #     extraPortals = with pkgs; [
  #       xdg-desktop-portal-wlr
  #     ];
  #   };
  # };
  #
  # # GnuPG with fix
  # programs = {
  #   gnupg.agent = {
  #     pinentryFlavor = "curses";
  #     enable = true;
  #   };
  # };
  # environment.shellInit = ''
  #   export GPG_TTY="$(tty)"
  #   gpg-connect-agent /bye
  # '';
}
