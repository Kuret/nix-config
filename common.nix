{ pkgs, lib, newmpkg, ... }:

{
  # Automatic cleanup
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Programs
  environment.systemPackages = with pkgs; [
    fish direnv any-nix-shell                 # Fish
    tmux wget ripgrep heroku universal-ctags  # CLI Tools
    git gh nix-prefetch-github                # Git
    kitty alacritty                           # Terminal
    neovim                                    # Editor
  ];

  fonts.fonts = with pkgs; [
    (callPackage ./my-pkgs/ttf-ligaconsolas-nerd-font.nix {})
  ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.users.rick = {
    description = "rick";
    shell = pkgs.fish;
  };

  # PostgresQL
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_15;
  services.postgresql.authentication = lib.mkForce ''
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    local   all             all                                     trust
    host    all             all             127.0.0.1/32            trust
    host    all             all             ::1/128                 trust
  '';

  # Locale
  time.timeZone = "Europe/Amsterdam";

  # Nix config and state
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "22.11";
}
