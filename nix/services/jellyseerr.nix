{...}: {
  virtualisation.oci-containers.containers."jellyseerr" = {
    image = "fallenbagel/jellyseerr:1.9.2";
    autoStart = true;
    volumes = [
      "/mnt/data/jellyseerr:/app/config"
    ];
    ports = [
      "5055:5055"
    ];
  };
  services.caddy = {
    virtualHosts = {
      "request.theholytachanka.com".extraConfig = ''
        reverse_proxy :5055 {
            header_down X-Real-IP {http.request.remote}
            header_down X-Forwarded-For {http.request.remote}
        }
      '';
    };
  };
}
