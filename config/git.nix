{ pkgs, ... }:

{
  programs.gh.enable = true;

  programs.git.enable = true;
  programs.git.userEmail = "rick@littel.me";
  programs.git.userName = "Rick Littel";
  programs.git.ignores = [ "shell.nix" "tags" ];
}
