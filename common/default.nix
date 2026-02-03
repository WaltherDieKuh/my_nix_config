{
  pkgs,
  inputs,
  outputs,
  config,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [
    ./greetd.nix
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services = {
    blueman.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = " set -g fish_greeting ";
  };

  networking = {
    firewall = rec {
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

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
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
  environment.systemPackages = with pkgs; [
    neovim
    rclone
    fuse
  ];
  programs.fuse.enable = true;
  programs.fuse.userAllowOther = true;
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
  };
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
