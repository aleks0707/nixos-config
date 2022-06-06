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

    config = mkIf cfg.enable {
      programs.git = {
        enable = true;
        userName = cfg.name;
        userEmail = cfg.email;
        signing = {
          signByDefault = true;
            key = null; # figure it out automatically
        };
<<<<<<< HEAD

        home.packages = [ pkgs.git ];
=======
        lfs.enable = true;
>>>>>>> fe6ad2ab2e4f6a5755014d4c3cb1ef8d84810447
      };
    };
  };
}