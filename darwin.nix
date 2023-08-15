{ config, pkgs, ..., }:

{
  imports = [
    ./common.nix
  ];

  # Use config from ~/nix-config
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "darwin-config=/Users/rick/dotfiles/hosts/${config.networking.hostName}/darwin-configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  security.pam.enableSudoTouchIdAuth = true;

  # Programs
  environment.systemPackages = with pkgs; [ ];
}
