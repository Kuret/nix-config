{ pkgs, ... }:

{
  imports = [ ../my-pkgs/universal-ctags.nix ];

  programs.universal-ctags.enable = true;
  programs.universal-ctags.config = ''
    --recurse=yes

    --exclude=*_test.js
    --exclude=*.css.json
    --exclude=*.lock
    --exclude=*.md
    --exclude=*.svg
    --exclude=_build
    --exclude=.devcontainer
    --exclude=.github
    --exclude=.vscode
    --exclude=deps
    --exclude=node_modules
    --exclude=package.json
    --exclude=package-lock.json
    --exclude=priv
    --exclude=rel
    --exclude=test/support/files
    --exclude=uploads
    --exclude=webpack*.js
  '';
}
