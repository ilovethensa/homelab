# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    #../../nix/configs/hardened
    ../../nix/profiles/desktop.nix
    ../../nix/configs/persist.nix
    ../../nix/configs/gaming.nix
    ../../nix/users/tht
    ../../nix/users/tht/home.nix
  ];

  services.xserver.enable = true;
  #services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.wayland.enable = true;
  #services.desktopManager.plasma6.enable = true;
  services.xserver.displayManager.startx.enable = true;
  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "viper";
  networking.firewall.enable = false;

  # Enable common container config files in /etc/containers
  #virtualisation.containers.enable = true;
  #virtualisation = {
  #  podman = {
  #    enable = true;

  #    # Create a `docker` alias for podman, to use it as a drop-in replacement
  #    dockerCompat = true;

  #    # Required for containers under podman-compose to be able to talk to each other.
  #    defaultNetwork.settings.dns_enabled = true;
  #  };
  #};
  # Useful other development tools
  environment.systemPackages = with pkgs; [
    distrobox
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    #docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
