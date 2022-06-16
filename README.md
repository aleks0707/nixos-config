# nixos-config
My NixOS configuration with [flakes](https://nixos.wiki/wiki/Flakes),
[flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus),
[home-manager](https://github.com/nix-community/home-manager) and
[impermanence](https://github.com/nix-community/impermanence).

## Setting up QEMU
For the VM host
```
$ qemu-img create -f qcow2 -o preallocation=metadata nixos.img 30G
$ qemu-system-x86_64 -hda nixos.img -cdrom nixos-minimal.iso -m 4G -smp 2 \
  -netdev tap,id=netdev0,ifname=tap0 -device e1000,netdev=netdev0 \
  -rtc base=localtime -accel hax -boot dc
```

## Installation
```
$ mkfs.btrfs -L nixos /dev/sda1
$ mkswap -L swap /dev/sda2
$ mount -t tmpfs none /mnt
$ mkdir -p /mnt/{nix,etc/nixos,var/{log,lib}}
$ mount /dev/disk/by-label/nixos /mnt/nix
$ mkdir -p /mnt/nix/persist/{etc/nixos,var/{log,lib}}
$ mount -o bind /mnt/nix/persist/etc/nixos /mnt/etc/nixos
$ mount -o bind /mnt/nix/persist/var/log /mnt/var/log
$ mount -o bind /mnt/nix/persist/var/lib /mnt/var/lib
$ nix-shell -p git
$ nixos-install --flake '.#<host>' --no-root-passwd
```

## Updating flake.lock
```
$ nix flake update
```

## Rebuilding
```
$ sudo nixos-rebuild switch --flake '.#'
```
or for short
```
$ rebuild
```

## Secrets
Make sure to have set safe permissions for the secrets
```
$ chmod 0600 secrets/*
```

In order to access the secrets, setup `git-crypt` with the keyfile
```
$ git-crypt unlock /path/to/keyfile
```

Import the private GPG key
```
$ gpg --import secrets/gpg_git_key
```

Add the private SSH keys to `ssh-agent`
```
$ ssh-add secrets/ssh_git_key
```
