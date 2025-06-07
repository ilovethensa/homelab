{pkgs, ...}: {
  hardware.opengl.driSupport32Bit = true;
  programs = {
    gamemode.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
  };
  environment.systemPackages = with pkgs; [
    lutris
    wineWowPackages.waylandFull
  ];
}
