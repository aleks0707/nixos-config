{
  description = "A NixOS configuration that reeks of darkness";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    inherit (nixpkgs) lib;

    system = "x86_64-linux"; # default

    util = import ./lib {
      inherit system pkgs home-manager lib;
      overlays = (pkgs.overlays);
    };

    inherit (util) user;
    inherit (util) host;

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [];
    };
  in {
    homeManagerConfigurations = {
      dark = user.mkHMUser {
        userConfig = {
          git.enable = true;
        };
        username = "dark";
      };
    };

    nixosConfigurations = {
      vm = host.mkHost {
        system = "x86_64-linux";
        name = "vm";
        NICs = [ "eth0" ];
        kernelPackage = pkgs.linuxPackages;
        initrdMods = [ "sd_mod" "sr_mod" ];
        kernelMods = [];
        kernelParams = [];
        systemConfig = {
          efi.enable = true;
          hardware.cpu.intel.updateMicrocode = true;
          virtualisation.hypervGuest.enable = true;
          programs.vim.defaultEditor = true;
        };
        users = [{
          name = "dark";
          groups = [ "wheel" "networkmanager" "video" ];
          uid = 1000;
          shell = pkgs.bash;
        }];
        cpuCores = 2;
      };
    };
  };
}