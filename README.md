# nixos-config
My NixOS configuration with [flakes](https://nixos.wiki/wiki/Flakes),
[home-manager](https://github.com/nix-community/home-manager) and
[flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus).

## Installation
For the VM host, setup QEMU
```bash
$ qemu-img create -f qcow2 -o preallocation=metadata nixos.img 30G
$ qemu-system-x86_64 -hda nixos.img -cdrom nixos-minimal.iso -m 1G,slots=3,maxmem=4G -smp 2 -netdev tap,id=netdev0,ifname=tap0 -device e1000,netdev=netdev0 -rtc base=localtime -accel hax -boot dc
```

```bash
$ nix-shell -p git
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
