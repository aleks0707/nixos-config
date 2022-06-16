{ pkgs, config, lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd.availableKernelModules = [ "ata_piix" "floppy" "sd_mod" "sr_mod" ];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "size=2G" "mode=755" ];
  };
  fileSystems."/home/dark" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "size=2G" "mode=777" ];
  };
  fileSystems."/nix" = {
    label = "nixos";
    fsType = "btrfs";
    options = [ "compress=lzo" "noatime" ];
  };
  services.btrfs.autoScrub.enable = true;
  swapDevices = [
    { label = "swap"; }
  ];

  users.mutableUsers = false;
  users.users.root.initialPassword = "root";
  user.name = "dark"; # used to specify the user in modules
  users.users.dark = {
    isNormalUser = true;
    initialPassword = "dark";
    useDefaultShell = true;
    extraGroups = [ "wheel" ];
    uid = 1000;
  };

  time.timeZone = "Europe/Tallinn";

  networking.useDHCP = true;
  networking.resolvconf.extraOptions = [
    "nameserver 1.1.1.1"
    "nameserver 1.0.0.1"
  ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  system.stateVersion = "22.05"; # Don't change. May break stateful data compability

  environment = {
    defaultPackages = with pkgs; [
      vim
      rsync
      strace
    ];
    variables = {
      EDITOR = "vim";
    };
    persistence."/nix/persist/system" = {
      directories = [
        "/etc/nixos"
        # "/etc/NetworkManager" 
        "/var/log"
        "/var/lib"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
      ];
    };
  };

  modules = {
    nix-optimize = {
      enable = true;
      cores = 2;
    };
    zsh.enable = true;
    dev = {
      tools = {
        git.enable = true;
        gpg.enable = true;
        gpg.pinentryFlavor = "curses";
        direnv.enable = true;
      };
    };
  };

  services.openssh.enable = true;
  users.users.dark.openssh.authorizedKeys.keyFiles = [ ../../secrets/ssh_host_key.pub ];
  services.vscode-server.enable = true;

  programs.fuse.userAllowOther = true;
  home-manager.users.dark.home = {
    file = {
      ".zshrc".source = ../../configs/.zshrc;
    };
    persistence."/nix/persist/home/dark" = {
      directories = [
        "Desktop"
        ".gnupg"
        ".ssh"
        ".local/share/keyrings"
        ".local/share/direnv"
      ];
      allowOther = true;
    };
  };
}
