{ pkgs, config, lib, ... }:
{
  inputs = [
    ./programs.nix
  ];

  boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  systemd-boot.enable = true;
  efi.canTouchEfiVariables = true;

  filesystems."/" = {
    label = "nixos";
    fsType = "ext4";
  };
  filesystems."/boot" = {
    label = "boot";
    fsType = "vfat";
  };
  swapDevices = [
    { label = "swap"; }
  ];

  user.name = "dark";
  users.users.dark = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [
      "wheel"
    ];
    # passwordFile = "password-secret.txt";
    uid = 1000;
  };

  time.timeZone = "Europe/Tallinn";

  networking.useDHCP = true;

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  virtualisation.hypervGuest = {
    enable = true;
    videoMode = "1024x768";
  };

  system.stateVersion = "22.05"; # Don't change. May break stateful data compability

  environment = {
    defaultPackages = with pkgs; [
      vim
      strace
    ];
    variables = {
      EDITOR = "vim";
    };
  };

  modules = {
    nix-optimize.enable = true;
    zsh.enable = true;
    dev = {
      tools = {
        git.enable = true;
        git.pinentryFlavor = "curses";
        gpg.enable = true;
        direnv.enable = true;
      };
    };
  };
}