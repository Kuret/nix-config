{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;
  nodejs = nodejs-18_x;

  elixir = (beam.packagesWith erlangR26).elixir_1_15.override {
    version = "1.15.0-otp-26";
    rev = "9fd85b06dcb74217108cd0bdf4164b6cd7f9e667";
    sha256 = "o5MfA0UG8vpnPCH1EYspzcN62yKZQcz5uVUY47hOL9w=";
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

  shellHook = ''
    export ERL_AFLAGS="-kernel shell_history enabled"
  '';
}
