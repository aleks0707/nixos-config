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
        rebuild = "sudo nixos-rebuild switch --flake '.#'";
        gpg-connect-agent = "gpg-connect-agent updatestartuptty /bye 1>/dev/null";
      };
      promptInit = ''
        autoload -U promptinit && promptinit && prompt suse && setopt prompt_sp && PS1='[%n@%m:%~] %# '
      '';
    };

    users.defaultUserShell = pkgs.zsh;
  };
}