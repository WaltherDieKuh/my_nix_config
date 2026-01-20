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
    # Der Service startet erst, wenn das Internet da ist
    after = ["network-online.target"];
    wantedBy = [
      "default.target"
      "graphical-session.target"
    ];
    serviceConfig = {
      Type = "simple";
      # Wir erstellen den Ordner sicherheitshalber vorher
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive";

      # WICHTIG: KEIN --daemon hier!
      # --vfs-cache-mode writes ist wichtig, damit du Dateien bearbeiten kannst
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount gdrive:/ %h/GoogleDrive \
          --vfs-cache-mode writes \
          --umask 0022 \
          --uid $(id -u) \
          --gid $(id -g)
      '';

      # Sauber unmounten beim Beenden
      ExecStop = ''
        /run/wrappers/bin/fusermount -uz %h/GoogleDrive || true
      '';

      # Automatisch neu starten, falls die Verbindung mal abbricht
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  # 1. Der Service (Was soll ausgeführt werden?)
  systemd.user.services.rclone-bisync = {
    description = "Bidirektionaler Google Drive Sync";
    serviceConfig = {
      Type = "oneshot";
      # %h ist der Platzhalter für dein Home-Verzeichnis
      ExecStart = "${pkgs.rclone}/bin/rclone bisync gdrive:/ %h/CloudSync --vfs-cache-mode writes";
    };
  };

  # 2. Der Timer (Wann soll es ausgeführt werden?)
  systemd.user.timers.rclone-bisync = {
    description = "Timer für GDrive Sync alle 5 Minuten";
    timerConfig = {
      OnBootSec = "2m"; # Erster Start 2 Min nach dem Booten
      OnUnitActiveSec = "5m"; # Danach alle 5 Minuten
    };
    wantedBy = ["timers.target"]; # Sorgt dafür, dass der Timer startet
  };
}
