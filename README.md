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