{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.universal-ctags;
in {
  options = {
    programs.universal-ctags = {
      enable = mkEnableOption "UniversalCtags";

      config = mkOption {
        type = types.lines;
        default = { };
        example = literalExpression ''
          --langdef=example
          --langmap=example:.example
          --regex-example=/[A-Za-z0-9_-]/
          --exclude=path
          --sort=no
          --options=example/example.ctags
        '';
        description = "ctags config file";
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.universal-ctags ];
      xdg.configFile."ctags/nix.ctags".text = cfg.config;
    })
  ];
}
