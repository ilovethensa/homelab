{pkgs, ...}: let
  run-gui = pkgs.writeShellScriptBin "run-gui" ''
    set -o allexport
    XDG_RUNTIME_DIR="/run/user/$(id -u)"
    eval "$(systemctl --user show-environment)"
    exec "$@"
  '';
  backup-server = pkgs.writeShellScriptBin "backup-server.sh" ''
    # Services to stop and start
    services="'docker-*' bazarr jellyfin radarr sonarr prowlarr homepage-dashboard mindustry miniflux transmission changedetection-io"

    # Remote systemctl function
    systemctl_remote() { ssh root@ikaros "sudo systemctl $@"; }

    # Stop services
    for service in $services; do systemctl_remote stop $service || { echo "Failed to stop $service on ikaros. Aborting backup."; exit 1; }; done

    # Backup with rsync
    rsync -av --exclude 'data/jellyfin/data/transcodes' --exclude 'data/jellyfin/cache' --exclude 'data/jellyfin/data/data/keyframes' --exclude 'data/jellyfin/data/data/subtitles' --exclude 'data/jellyfin/data/metadata/People' --exclude 'data/minecraft/commiemc/libraries' --exclude 'data/minecraft/commiemc/.fabric' --exclude 'data/minecraft/commiemc/mods' --exclude 'data/minecraft/commiemc/versions' --exclude 'data/radarr/MediaCover' --exclude 'data/sonarr/MediaCover' --exclude 'data/bazarr/cache' --exclude 'data/jellyfin/data/metadata/Studio' --exclude 'data/jellyfin/data/metadata/library' root@ikaros:/mnt/data ~/Documents/backup && echo "Backup completed successfully." || { echo "Rsync failed. Please check the logs for details."; exit 1; }

    # Start services
    for service in $services; do systemctl_remote start $service || { echo "Failed to start $service on ikaros."; exit 1; }; done
    tar -I 'zstd -19 --threads=4' -cvf data.tar.zst -C ~/Documents/backup
    tar -cf ~/Documents/backup/backup.tar ~/Documents/backup/data
    zstd --ultra -22 -T0 ~/Documents/backup/backup.tar -o ~/Documents/backup/backup.tar.zst

    echo "All services started successfully on ikaros."
  '';
in {
  home.packages = with pkgs; [
    grc
    uutils-coreutils-noprefix
    ripgrep
    gitoxide
    fd
    tealdeer
    crabz
    hex
    suckit
    nom
    statix
    deadnix
    just
    wl-clipboard-rs
    discordo
    yazi
    gurk-rs
    httpie
    hexyl
    btop
    pulsemixer
    moreutils
  ];
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
        ${pkgs.starship}/bin/starship init fish | source
        ${pkgs.nitch}/bin/nitch
        # export SUDO_PROMPT='[sudo] %p 🔒: '
      '';
      shellAliases = {
        ls = "${pkgs.eza}/bin/eza -la";
        cat = "${pkgs.bat}/bin/bat --paging=never";
        cp = "${pkgs.xcp}/bin/xcp";
        rm = "${pkgs.fuc}/bin/rmz";
        glow = "${pkgs.glow}/bin/glow --pager";
        htop = "${pkgs.bottom}/bin/btm --basic --tree --hide_table_gap --dot_marker --mem_as_value";
        ip = "${pkgs.iproute2}/bin/ip --color --brief";
        less = "${pkgs.bat}/bin/bat";
        dmesg = "${pkgs.util-linux}/bin/dmesg --human --color=always";
        tree = "${pkgs.eza}/bin/eza --tree";
        ping = "${pkgs.gping}/bin/gping";
        ask = "${pkgs.tgpt}/bin/tgpt";
        backup-server = "${backup-server}/bin/backup-server.sh";
        run-gui = "${run-gui}/bin/run-gui";
        reboot = "systemctl reboot";
        shutdown = "systemctl poweroff";
        gc = "git add . && git commit -m";
        gp = "git push";
        ps = "${pkgs.procs}/bin/procs";
        help = "${pkgs.tealdeer}/bin/tldr";
        imgur = "${pkgs.imgurbash2}/bin/imgurbash2";
      };
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        {
          name = "grc";
          inherit (pkgs.fishPlugins.grc) src;
        }
      ];
    };
  };
}
