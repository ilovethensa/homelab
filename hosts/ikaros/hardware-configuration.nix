# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/FE61-3063";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/89b248a1-456b-4d6f-8805-35316ffc970f";
      fsType = "btrfs";
      options = ["subvol=@nix" "compress=zstd"];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/89b248a1-456b-4d6f-8805-35316ffc970f";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd"];
    };

    "/mnt/data" = {
      device = "/dev/disk/by-uuid/98655513-e41f-4377-8b36-15a6a46540e2";
      fsType = "btrfs";
      options = ["compress=zstd" "nofail"];
    };
    /*
       "/mnt/media" = {
      device = "/dev/disk/by-uuid/23fc1491-b1f6-4e69-82e7-6135e4c0a3f1";
      fsType = "btrfs";
      options = [ "compress=zstd" "nofail" ];
    };
    */
  };
  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
