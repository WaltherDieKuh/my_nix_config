{
  pkgs,
  lib,
  inputs,
  outputs,
  config,
  isDesktop ? false,
  isLaptop ? false,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [
    ./greetd.nix
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # Sound and Services
  services = {
    blueman.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
    pipewire = {
      enable = true;
      jack.enable = true;
    };
    upower.enable = true;
    xserver.enable = false;
  };

  networking = {
    firewall = rec {
      # Wir öffnen Port 5353 (UDP) für mDNS (Spotify Connect Discovery / Zeroconf)
      # und TCP/UDP 5000 explizit für den spotifyd Daemon
      allowedTCPPorts = [ 5000 ];
      allowedUDPPorts = [ 5353 5000 ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };

  # Network and User Basics
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  environment.variables = {
    XKB_DEFAULT_LAYOUT = "de";
    XKB_DEFAULT_VARIANT = "nodeadkeys";
  };

  # Common Nix settings
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  # Overlay-Einbindung
  nixpkgs.overlays = [ 
    outputs.overlays.custom 
    outputs.overlays.neovim
  ];

  # Home-Manager Konfiguration defaults
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit isDesktop isLaptop inputs outputs; };
    backupFileExtension = "backup";
    users.willi = {
      imports = [
        inputs.stylix.homeModules.stylix
        ../home/willi.nix
        ../modules/default.nix
      ];
    };
  };

  # Boot and Grub Theme (minecraft)
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    minegrub-theme = {
      enable = true;
      splash = "C++ - alles kann, nichts muss";
      background = "background_options/1.8  - [Classic Minecraft].png";
      boot-options-count = 4;
    };
  };
  boot.plymouth = {
    enable = true;
    theme = "minecraft";
    themePackages = [pkgs.minecraft-plymouth-theme];
  };
  boot.kernelParams = [
    "quiet"
    "splash"
  ];
  boot.initrd.availableKernelModules = lib.mkBefore ["i915"];

  programs.fish = {
    enable = true;
    interactiveShellInit = " set -g fish_greeting ";
  };
  programs.hyprland.enable = true;

  system.stateVersion = "25.05";

  users.users.willi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.fish;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
  ];

  environment.systemPackages = with pkgs; [
    neovim
    rclone
    fuse
    texliveFull
    python315
    vim
    git
    git-lfs
    papirus-icon-theme
    hicolor-icon-theme
    font-awesome
    emote
    nemo
    comma
    xournalpp
    networkmanager
    localsend
    zip
    unzip
    sleuthkit
    wineWow64Packages.waylandFull
    htop
    btop
    wireplumber
    libgtop
    bluez
    bluez-tools
    dart-sass
    upower
    gvfs
    gtksourceview3
    libsoup_3
    bottles
  ];
  networking.hosts = {
    "127.0.0.1" = ["localhost"];
  };
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    extest.enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.fuse.enable = true;
  programs.fuse.userAllowOther = true;
  
  # RClone Google Drive service

  systemd.user.services.rclone-gdrive = {
    description = "Google Drive Mount (rclone)";
    after = ["network-online.target"];
    wantedBy = ["default.target"]; # graphical-session ist oft zu spät/unzuverlässig

    # Hier fügen wir den Pfad zu den Wrappern hinzu, damit rclone fusermount findet
    path = [
      "/run/wrappers"
      pkgs.rclone
    ];

    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive";

      # Wir entfernen --uid und --gid komplett, da rclone als User
      # diese IDs automatisch richtig setzt.
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount gdrive:/ %h/GoogleDrive \
          --vfs-cache-mode writes \
          --umask 0022
      '';

      ExecStop = "/run/wrappers/bin/fusermount -uz %h/GoogleDrive";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  # 1. Der Service (Der eigentliche Befehl)
  systemd.user.services.rclone-bisync = {
    description = "Google Drive Bidirektionaler Sync";
    # Der Dienst wartet, bis das Netzwerk bereit ist
    after = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      # Der Befehl für den regelmäßigen Sync (OHNE --resync!)
      ExecStart = "${pkgs.rclone}/bin/rclone bisync \"gdrive:/Meine Dateien\" \"%h/Meine Dateien\"";
      # Falls der Sync fehlschlägt, versuchen wir es beim nächsten Mal wieder
      Restart = "no";
    };
  };

  # 2. Der Timer (Der Wecker für den Service)
  systemd.user.timers.rclone-bisync = {
    description = "Timer für rclone bisync alle 15 Minuten";
    timerConfig = {
      OnBootSec = "5m"; # Erster Start 5 Min nach dem Booten
      OnUnitActiveSec = "15m"; # Danach alle 15 Minuten
    };
    wantedBy = ["timers.target"];
  };
}
