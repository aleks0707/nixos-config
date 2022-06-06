{
  description = "dark's NixOS, Home-Manager and Flake-Utils-Plus flake";

  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixos-vscode-server.url = "github:mudrii/nixos-vscode-ssh-fix/main";
  };

  outputs = inputs@{ self, utils, nixpkgs, unstable, home-manager, nixos-vscode-server, ... }:
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
          
          {
            imports = [ inputs.auto-fix-vscode-server.nixosModules.system ];
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