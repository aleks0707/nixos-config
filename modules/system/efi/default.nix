{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.jd.efi;
in {
  options.jd.efi = {
    enable = mkOption {
      description = "Enable EFI support";
      type = types.bool;
      default = false;
    };

    config = mkIf (cfg.enable) {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}