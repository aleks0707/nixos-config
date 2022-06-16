{
  description = "dark's NixOS, Home-Manager and Flake-Utils-Plus flake";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    nixos-vscode-server.url = "github:darkn07/nixos-vscode-server";
  };

  outputs = inputs@{self, utils, nixpkgs, nixos-stable, home-manager, impermanence, nixos-vscode-server, ... }:
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
            home-manager.users.dark.imports = [ "${impermanence}/home-manager.nix" ];
          }
          impermanence.nixosModules.impermanence
          nixos-vscode-server.nixosModules.system
        ];
      };

      nixosModules = exportModules [
        ./hosts/vm
      ];

      hosts = {
        vm = {
          channelName = "nixpkgs";
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
          shellHook = ''
            gpg-connect-agent updatestartuptty /bye > /dev/null
          '';
        };
      };
    };
}
