{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcTC/l7AvXzPhEJ+8PPy7NG84G7VtgJ1QWsW+xcFZgb tht"
    ];
    # FIXME: Replace with your username
    tht = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialHashedPassword = "$6$a5OrpClAzTuokFBn$ODzSyW8pn6QEJsR1Kjsgyy.6rUqV2S865jWiDm4qXRPV26UnF29IfC6HOowInNzCRYrtFk4CwpjGAL/zni.FC/";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcTC/l7AvXzPhEJ+8PPy7NG84G7VtgJ1QWsW+xcFZgb tht"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "audio" "video" "gamemode"];
    };
  };
}
