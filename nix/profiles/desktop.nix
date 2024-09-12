{pkgs, ...}: {
  imports = [
    ./general.nix
    ../configs/audio.nix
  ];
  security.polkit.enable = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
