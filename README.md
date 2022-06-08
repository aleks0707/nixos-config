# nixos-config
My NixOS configuration with [flakes](https://nixos.wiki/wiki/Flakes),
[home-manager](https://github.com/nix-community/home-manager) and
[flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus).

At the moment, I operate a Hyper-V VM on Windows. I access it through SSH on
VS Code and PuTTY.

## Installation
```bash
$ nixos-install --flake '.#<host>'
```
Set the password for any users
```bash
$ passwd dark
```

## Updating flake inputs
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
Make sure to set safe permissions for the secrets
```bash
$ chmod 0600 secrets/*
```

In order to access the secrets, setup `git-crypt` with the keyfile
```bash
$ git-crypt unlock /path/to/keyfile
```

Import the public and private GPG keys
```bash
$ gpg --import secrets/public_gpg
$ gpg --import secrets/private_gpg
```

Add the private SSH key to `ssh-agent`
```bash
$ ssh-add secrets/private_ssh
```

Before you run any command that depends on `gpg-agent` (like `git pull`) on a new tty,
update the startup tty otherwise `gpg-connect-agent` will throw out an error
```bash
$ gpg-connect-agent
```
which is aliased to
```bash
$ gpg-connect-agent updatestartuptty /bye 1>/dev/null
```
