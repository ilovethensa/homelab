{ lib, config, pkgs, ... }: {
  # Disable nix channels. Use flakes instead.
  nix.channel.enable = lib.mkDefault false;

  # Fallback quickly if substituters are not available.
  nix.settings.connect-timeout = lib.mkDefault 5;

  # The default at 10 is rarely enough.
  nix.settings.log-lines = lib.mkDefault 25;

  # De-duplicate store paths using hardlinks except in containers
  # where the store is host-managed.
  nix.optimise.automatic = lib.mkDefault (!config.boot.isContainer);

  # Avoid disk full issues
  nix.settings.max-free = lib.mkDefault (3000 * 1024 * 1024);
  nix.settings.min-free = lib.mkDefault (512 * 1024 * 1024);

  # TODO: cargo culted.
  nix.daemonCPUSchedPolicy = lib.mkDefault "batch";
  nix.daemonIOSchedClass = lib.mkDefault "idle";
  nix.daemonIOSchedPriority = lib.mkDefault 7;

  # Make builds to be more likely killed than important services.
  # 100 is the default for user slices and 500 is systemd-coredumpd@
  # We rather want a build to be killed than our precious user sessions as builds can be easily restarted.
  systemd.services.nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 250;

  # Avoid copying unnecessary stuff over SSH
  nix.settings.builders-use-substitutes = true;

  # Caches in trusted-substituters can be used by unprivileged users i.e. in
  # flakes but are not enabled by default.
  nix.settings.trusted-substituters = [
    "https://nix-community.cachix.org"
    "https://cache.garnix.io"
    "https://numtide.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
  ];

  nix.package = lib.mkDefault pkgs.nixVersions.latest;

  # Enable flakes
  nix.settings.experimental-features = [
    # for container in builds support
    "auto-allocate-uids"
    "cgroups"

    # Enable the use of the fetchClosure built-in function in the Nix language.
    "fetch-closure"

    # Allow derivation builders to call Nix, and thus build derivations recursively.
    "recursive-nix"

    # Enable the nix command
    "nix-command"
    # Enable flakes
    "flakes"
  ] ++ lib.optional
    (lib.versionAtLeast (lib.versions.majorMinor config.nix.package.version)
      "2.19")
    # Allow the use of the impure-env setting.
    "configurable-impure-env";

  # no longer need to pre-allocate build users for everything
  nix.settings.auto-allocate-uids = true;

  # for container in builds support
  nix.settings.system-features = lib.mkDefault [ "uid-range" ];
}
