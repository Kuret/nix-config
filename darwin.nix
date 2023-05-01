{ config, pkgs, ..., }:

{
  imports = [
    (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz}/nixos")
    ./common.nix
  ];

  # Use config from dotfiles
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/Users/rick/dotfiles/hosts/${config.networking.hostName}/darwin-configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  security.pam.enableSudoTouchIdAuth = true;

  # Programs
  environment.systemPackages = with pkgs; [ ];

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.users.rick = import ./home/home-darwin.nix;
}
