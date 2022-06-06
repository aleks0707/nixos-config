# nixos-config
My NixOS configuration with [flakes](https://nixos.wiki/wiki/Flakes),
[home-manager](https://github.com/nix-community/home-manager) and
[flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus).

## Installation
```bash
nixos-install --flake '.#<host>'
```

## Updating flake inputs)
```bash
nix flake update
```

## Rebuilding
```bash
sudo nixos-rebuild switch --flake '.#'
```

## Secrets
In order to access the secrets, setup git-crypt with
```bash
git-crypt unlock /path/to/keyfile
```