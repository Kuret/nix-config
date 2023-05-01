{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;
  nodejs = nodejs-18_x;

  elixir = (beam.packagesWith erlangR25).elixir.override {
    version = "1.14.4-otp-25";
    rev = "6f96693b355a9b670f2630fd8e6217b69e325c5a";
    sha256 = "mV40pSpLrYKT43b8KXiQsaIB+ap+B4cS2QUxUoylm7c=";
  };
in

mkShell {
  buildInputs = [ elixir nodejs direnv cmake imagemagick git gh ]
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
