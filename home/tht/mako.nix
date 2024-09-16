{...}: {
  services.mako = {
    enable = true;
    extraConfig = ''
      ignore-timeout=1
      anchor=top-right
    '';
  };
}
