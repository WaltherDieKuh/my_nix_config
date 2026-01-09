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
  ];
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
  };
  systemd.user.services.rclone-gdrive = {
    Unit = {
      Description = "Google Drive (Rclone)";
      After = ["network-online.target"]; # Wartet auf Internet
    };

    Service = {
      Type = "simple";
      # %h ist dein Home-Verzeichnis, das versteht systemd automatisch
      ExecStart = "${pkgs.rclone}/bin/rclone mount gdrive:/ %h/GoogleDrive --vfs-cache-mode writes --dir-cache-time 24h";

      # WICHTIG: fusermount braucht den System-Pfad wegen Root-Rechten (SUID)
      ExecStop = "/run/wrappers/bin/fusermount -u %h/GoogleDrive";

      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install = {
      WantedBy = ["default.target"]; # Startet beim Einloggen
    };
  };
}
