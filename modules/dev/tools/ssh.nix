{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.modules.dev.tools.ssh;
in
{
  options.modules.dev.tools.ssh = {
    enable = mkEnableOption "SSH client configuration";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      startAgent = true;
    };
  };
}