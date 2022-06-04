{ pkgs, config, lib, ... }:
{
  imports = [
    ./filesystem
    ./efi
  ];
}