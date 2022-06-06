# nixos-config
My NixOS configuration.

## Installation
```bash
nixos-install --flake '.#<host>'
```

## Updating flake inputs
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