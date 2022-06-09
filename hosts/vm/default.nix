{ pkgs, config, lib, ... }:
{
  boot = {
    initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
    initrd.kernelModules = [];
    kernelModules = [];
    extraModulePackages = [];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" = {
    label = "nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
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
    uid = 1000;
  };

  time.timeZone = "Europe/Tallinn";

  networking.useDHCP = true;

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
  services.vscode-server.enable = true;

  home-manager.users.${config.user.name}.home.file = {
    ".zshrc".source = ../../configs/.zshrc;
  };
}
