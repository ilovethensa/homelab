{outputs, lib, inputs, config, ...}: {
  imports = [
    ../services/openssh.nix
    ../configs/boot.nix
    ../configs/networking.nix
    ../configs/nix.nix
    ../configs/sudo.nix
    ../configs/upgrade-diff.nix
  ];
  users.users.root.initialHashedPassword = "$6$a5OrpClAzTuokFBn$ODzSyW8pn6QEJsR1Kjsgyy.6rUqV2S865jWiDm4qXRPV26UnF29IfC6HOowInNzCRYrtFk4CwpjGAL/zni.FC/";
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Opinionated: disable global registry
      #flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Work around for https://github.com/NixOS/nixpkgs/issues/124215
  documentation.info.enable = false;

  environment = {
    # This is pulled in by the container profile, but it seems broken and causes
    # unnecessary rebuilds.
    noXlibs = false;
    # Don't install the /lib/ld-linux.so.2 stub. This saves one instance of
    # nixpkgs.
    ldso32 = null;
  };

  # Ensure a clean & sparkling /tmp on fresh boots.
  boot.tmp.cleanOnBoot = lib.mkDefault true;
}
