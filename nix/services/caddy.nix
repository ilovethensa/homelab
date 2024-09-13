{ ... }: {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "theholytachanka.com".extraConfig = ''
        encode gzip
        file_server
        root * ${
          pkgs.runCommand "testdir" { } ''
            mkdir "$out"
            echo hello world > "$out/index.html"
          ''
        }
      '';
      "pwned.page".extraConfig = ''
        encode gzip
        file_server
        root * ${
          pkgs.runCommand "testdir" { } ''
            mkdir "$out"
            echo hello world > "$out/index.html"
          ''
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 80 443 ];
}
