# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{...}: {
  # You can import other NixOS modules here
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../../nix/configs/persist.nix
    ../../nix/configs/motd.nix
    ../../nix/services/arr.nix
    ../../nix/services/jellyseerr.nix
    ../../nix/services/caddy.nix
    ../../nix/profiles/server.nix
    ../../nix/users/tht
  ];

  # TODO: Set your hostname
  networking.hostName = "ikaros";
  virtualisation.lxd.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
