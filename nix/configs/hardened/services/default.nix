{...}: {
  import = [
    ./NetworkManager-dispatcher.nix
    ./autovt.nix
    ./dbus.nix
    ./nix-daemon.nix
    ./sshd.nix
    ./systemd-rfkill.nix
    ./NetworkManager.nix
    ./blocky.nix
    ./default.nix
    ./nscd.nix
    ./systemd-ask-password-console.nix
    ./systemd-udevd.nix
    ./accounts-daemon.nix
    ./bluetooth.nix
    ./display-manager.nix
    ./reload-systemd-vconsole-setup.nix
    ./systemd-ask-password-wall.nix
    ./user.nix
    ./acipd.nix
    ./colord.nix
    ./docker.nix
    ./rescue.nix
    ./systemd-journald.nix
    ./wpa_supplicant.nix
    ./auditd.nix
    ./cups.nix
    ./getty.nix
    ./rtkit.nix
    ./systemd-machined.nix
  ];

}
