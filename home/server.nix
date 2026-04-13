{ config, pkgs, ... }:

{
  # Basiseinstellungen für den Home Manager des "server" Users
  home.username = "server";
  home.homeDirectory = "/home/server";

  # Diese Version sollte in der Regel mit deiner NixOS stateVersion übereinstimmen
  home.stateVersion = "23.11"; 

  # Erlaube Home Manager sich selbst zu verwalten
  programs.home-manager.enable = true;

  # ===== CLI-Helfer Tools =====
  # Pakete, die nur dieser Benutzer braucht, aber nicht das ganze System.
  home.packages = with pkgs; [
    curl
    openssl
    jq
    dig       # Für DNS Lookups / Fehlersuche
    tmux      # Session Management für Wartungsarbeiten (sehr nützlich über SSH)
    tree      # Verzeichnisstrukturen schnell überblicken
  ];

  # ===== Shell Aliase =====
  # Praktische Abkürzungen für Server-Administration
  home.shellAliases = {
    # NixOS Rebuild leicht gemacht
    rebuild = "sudo nixos-rebuild switch --flake /home/server/my_nix_config#serverHome";

    # Schneller Zugriff auf System-Logs
    syslog = "sudo journalctl -xe";

    # Nextcloud Wartung (NixOS generiert 'nextcloud-occ' als Wrapper für 'sudo -u nextcloud php occ')
    occ = "sudo nextcloud-occ";
    
    # Nextcloud Setup-Service log checken
    nj = "sudo journalctl -u nextcloud-setup.service -e";

    # Docker-Style Logging für Systemd
    log-nc = "sudo journalctl -u nextcloud-setup.service -f";
    log-nginx = "sudo journalctl -u nginx.service -f";
    log-vw = "sudo journalctl -u vaultwarden.service -f";
    log-adg = "sudo journalctl -u adguardhome.service -f";
  };

  # ===== Bash Einstellungen (Optional, falls du Bash nutzt) =====
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
}
