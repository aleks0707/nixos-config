# nixos-config
My NixOS configuration with [flakes](https://nixos.wiki/wiki/Flakes),
[home-manager](https://github.com/nix-community/home-manager) and
[flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus).

At the moment, I operate a QEMU virtual machine on Windows. I access it through SSH on
VS Code and PuTTY.

## Installation
```bash
$ nixos-install --flake '.#<host>' --no-root-passwd
```

## Updating flake.lock
```bash
$ nix flake update
```

## Rebuilding
```bash
$ sudo nixos-rebuild switch --flake '.#'
```
or for short
```bash
$ rebuild
```

## Secrets
Make sure to have set safe permissions for the secrets
```bash
$ chmod 0600 secrets/*
```

In order to access the secrets, setup `git-crypt` with the keyfile
```bash
$ git-crypt unlock /path/to/keyfile
```

Import the private GPG key
```bash
$ gpg --import secrets/gpg_git_key
```

Add the private SSH keys to `ssh-agent`
```bash
$ ssh-add secrets/ssh_git_key
```
