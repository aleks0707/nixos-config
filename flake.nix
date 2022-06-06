{
  description = "dark's NixOS, Home-Manager and Flake-Utils-Plus flake";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = inputs@{ self, utils, nixpkgs, unstable, home-manager, vscode-server, ... }:
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

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }

          vscode-server.nixosModules.vscode-server
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