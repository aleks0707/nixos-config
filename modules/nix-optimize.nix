{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.nix-optimize;
in
{
  options.modules.nix-optimize = {
    enable = mkEnableOption "Nix optimizations";
    cores = mkOption {
      type = types.int;
      default = 1;
    };

    config = mkIf cfg.enable {
      nix.settings = {
        auto-optimise-store = true;
        cores = cfg.cores;
        max-jobs = cfg.cores;
      };
    };
  };
}