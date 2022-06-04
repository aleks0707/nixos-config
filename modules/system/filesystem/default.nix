{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.jd.filesystem;
in {
  options.jd.filesystem = {
    rootLabel = mkOption {
      description = "Label for root filesystem";
      type = types.str;
      default = "nixos";
    };

    rootFs = mkOption {
      description = "Filesystem for root";
      type = types.str;
      default = "ext4";
    };

    bootLabel = mkOption {
      description = "Label for /boot filesystem";
      type = types.str;
      default = "boot";
    };

    swapLabel = mkOption {
      description = "Label for swap";
      type = types.str;
      default = "swap";
    };

    config = {
      fileSystems."/" = {
        label = cfg.rootLabel;
        fsType = cfg.rootFs;
      };
      fileSystems."/boot" = {
        device = cfg.bootLabel;
        fsType = "vfat";
      };
      swapDevices = [
        { device = cfg.swapLabel; }
      ];
    };
  };
}