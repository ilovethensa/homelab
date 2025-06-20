# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs,
  outputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./sway.nix
    #./firefox.nix
    ./vscode.nix
    ./fish.nix
    ./mako.nix
    #./chromium.nix
    ./i3status.nix
  ];

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

  # TODO: Set your username
  home = {
    username = "tht";
    homeDirectory = "/home/tht";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    tor-browser
    zed-editor
    qbittorrent
    vesktop
    rustup
    radicle-node
    thunderbird
    nixd
    gimp3
    nil
    thorium
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "thorium-browser.desktop";
      "x-scheme-handler/http" = "thorium-browser.desktop";
      "x-scheme-handler/https" = "thorium-browser.desktop";
      "x-scheme-handler/about" = "thorium-browser.desktop";
      "x-scheme-handler/unknown" = "thorium-browser.desktop";
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userEmail = "me@theholytachanka.com";
    userName = "John Smith";
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vkcapture
      obs-pipewire-audio-capture
    ];
  };

  gtk = {
    #enable = true;

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };

    cursorTheme = {
      package = pkgs.vimix-cursors;
      name = "Vimix-cursors";
    };
    iconTheme.name = "MoreWaita";
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt6;
    };
  };

  home.file.".local/share/icons/MoreWaita/".source = inputs.morewaita;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
