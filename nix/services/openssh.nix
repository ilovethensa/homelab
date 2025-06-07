{...}: {
  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "yes";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      X11Forwarding = false;
      KbdInteractiveAuthentication = true;
      PasswordAuthentication = true;
      UseDns = true;
      # unbind gnupg sockets if they exists
      StreamLocalBindUnlink = true;
    };
  };
}
