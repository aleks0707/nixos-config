{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.modules.dev.tools.gpg;
in
{
  options.modules.dev.tools.gpg = {
    enable = mkEnableOption "GPG configuration";
    pinentryFlavor = mkOption {
      type = types.str;
      default = "gtk2";
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      programs.gpg.enable = true;

      services.gpg-agent = {
        enable = true;
        pinentryFlavor = cfg.pinentryFlavor;
      };
    };
  };
}