{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.zsh;
in
{
  options.modules.zsh.enable = mkEnableOption "Zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        nrs = "sudo nixos-rebuild switch";
      };
    };

    users.defaultUserShell = pkgs.zsh;
  };
}