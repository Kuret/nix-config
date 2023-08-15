{ config, pkgs, lib, ... }:
let
  nix-gaming = import (builtins.fetchTarball "https://github.com/fufexan/nix-gaming/archive/master.tar.gz");
in {
  imports = [
    "${nix-gaming}/modules/pipewireLowLatency.nix"
    ./common.nix
  ];

  # Use config from ~/nix-config
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

    brave         # Browser
    cider         # Apple Music
    wl-clipboard  # Utilities
    libnotify     # Notifier

    # Gnome Utils
    dconf2nix
    gnome.dconf-editor
    gnome3.gnome-tweaks

    # Gnome Extensions
    gnomeExtensions.media-controls

    # Theme
    phinger-cursors
    noto-fonts
  ];

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
    extraGroups = [ "wheel" "networkmanager" "input" "video" "libvirtd" "adbusers" ];
  };

  # Android
  programs.adb.enable = true;

  # GUI
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Steam
  programs.steam.enable = true;

  # 1Password
  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "rick" ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Print service
  services.printing.enable = true;
}
