{pkgs, ...}: {
  imports = [./general.nix ../configs/audio.nix];
  security.polkit.enable = true;
  fonts.packages = with pkgs; [nerd-fonts.fira-code];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };
}
