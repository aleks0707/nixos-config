{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.modules.dev.tools.vs-code-ssh;
in
{
  options.modules.dev.tools.vs-code-ssh = {
    enable = mkEnableOption "VS Code remote SSH server";
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = {
      services.vscode-server.enable = true;
    };
  };
}