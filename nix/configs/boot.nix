{...}: {
  boot.supportedFilesystems = [ "btrfs" ]; 
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.efi.canTouchEfiVariables = true;
}