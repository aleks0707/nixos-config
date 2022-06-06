{
  description = "dark's NixOS, Home-Manager and Flake-Utils-Plus flake";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = inputs@{ self, utils, nixpkgs, unstable, home-manager, ... }:
  let
    inherit (utils.lib) mkFlake exportModules;
  in
    mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig.allowUnfree = true;

      hostDefaults = {
        system = "x86_64-linux";
        modules = [
          ./modules
          ./configs

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };

      nixosModules = exportModules [
        ./hosts/vm
      ];

      hosts = {
        vm = {
          channelName = "unstable";
          modules = with self.nixosModules; [ vm ];
        };
      };

      outputsBuilder = channels: with channels.nixpkgs; {
        devShell = mkShell {
          name = "nixos-config";
          buildInputs = [
            nixpkgs-fmt
            git-crypt
          ];
        };
      };
    };
}