{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;
  nodejs = nodejs-18_x;

  elixir = (beam.packagesWith erlangR26).elixir_1_15.override {
    version = "1.15.2-otp-26";
    sha256 = "sha256-JLDjLO78p1i3FqGCbgl22SZFGPxJxKGKskzAJhHV8NE=";
    rev = "7f7a8bca99fa306a41a985df0018ba642e577d4d";
  };
in

mkShell {
  buildInputs = [ erlang_26 elixir nodejs direnv gcc cmake gnumake imagemagick git gh ]
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
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';
}
