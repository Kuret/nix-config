{
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  imports = [
    ../config/alacritty.nix
    ../config/fish.nix
    ../config/tmux.nix
    ../config/ctags.nix
    ../config/git.nix
    ../config/nvim.nix
  ];
}
