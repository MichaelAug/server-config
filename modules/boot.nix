{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.supportedFilesystems = [ "ntfs" ];

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;
}
