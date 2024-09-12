{inputs, ...}: {
    imports = [
        inputs.nixarr.nixosModules.default
    ];
    nixarr = {
      enable = true;
      # These two values are also the default, but you can set them to whatever
      # else you want
      # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
      mediaDir = "/data/media";
      stateDir = "/data/media/.state/nixarr";

      vpn = {
        enable = true;
        # WARNING: This file must _not_ be in the config git directory
        # You can usually get this wireguard file from your VPN provider
        wgConf = "/data/.secret/wg.conf";
      };

      jellyfin = {
        enable = true;
        openFirewall = true;
      };

      transmission = {
        enable = true;
        openFirewall = true;
        peerPort = 50000; # Set this to the port forwarded by your VPN
      };

      # It is possible for this module to run the *Arrs through a VPN, but it
      # is generally not recommended, as it can cause rate-limiting issues.
      bazarr = {
        enable = true;
        openFirewall = true;
      };
      lidarr = {
        enable = true;
        openFirewall = true;
      };
      prowlarr = {
        enable = true;
        openFirewall = true;
      };
      radarr = {
        enable = true;
        openFirewall = true;
      };
      readarr = {
        enable = true;
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        openFirewall = true;
      };
    };
}
