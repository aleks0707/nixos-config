{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.modules.dev.tools.git;
in
{
  options.modules.dev.tools.git = {
    enable = mkEnableOption "Git configuration";
    name = mkOption {
      type = types.str;
      default = "darkn07";
    };
    email = mkOption {
      type = types.str;
      default = "darkn4754+mail@gmail.com";
    };
    signingKey = mkOption {
      type = types.str;
      default = "3CD678F959EA3C01";
    };
  };

    config = mkIf cfg.enable {
      home-manager.users.${config.user.name} = {
        programs.git = {
          enable = true;
          userName = cfg.name;
          userEmail = cfg.email;
          signing = {
            signByDefault = true;
            key = cfg.signingKey;
          };
          lfs.enable = true;
          extraConfig.url = {
            "git@github.com:" = { insteadOf = [ "gh-ssh:" "github-ssh:" ]; };
            "https://github.com/" = { insteadOf = [ "gh:" "github:" ]; }; };
        };
      };
    };
}