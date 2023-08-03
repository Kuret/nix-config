{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;
  nixpkgs.overlays = [
    (final: prev: {
      stdenv = prev.stdenvAdapters.addAttrsToDerivation {
        NIX_CFLAGS_COMPILE = "${NIX_CFLAGS_COMPILE} -fmax-errors=0 -fsyntax-only";
        NIX_LDFLAGS = "";
      } prev.stdenv;
    })
  ];

  buildNodejs = pkgs.callPackage <nixpkgs/pkgs/development/web/nodejs/nodejs.nix> {};

  nodejs = buildNodejs {
    enableNpm = true;
    version = "7.10.0";
    sha256 = "3DTdFVJLqCH/yueyReq+hjHiYU1ePLj/CPv9rfWRnyE=";
  };

  ruby = ruby_2_7;
in

mkShell {
  buildInputs = [ ruby nodejs direnv gcc cmake gnumake imagemagick git gh ]
    ++ optional stdenv.isLinux libnotify # For ExUnit Notifier on Linux.
    ++ optional stdenv.isLinux inotify-tools # For file_system on Linux.
    ++ optional stdenv.isDarwin terminal-notifier # For ExUnit Notifier on macOS.
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      # For file_system on macOS.
      CoreFoundation
      CoreServices
    ]);

  LANG = "${if stdenv.isDarwin then "en_US" else "C"}.UTF-8";

  shellHook = ''
  '';
}
