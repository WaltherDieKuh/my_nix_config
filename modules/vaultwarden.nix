#{ config, pkgs, ... }:

{
  # ===== Vaultwarden (Bitwarden Server) =====
  services.vaultwarden = {
    enable = true;
    # Automatisches Backup-Verzeichnis aktivieren
    backupDir = "/var/backup/vaultwarden";
    
    config = {
      # Die URL, unter der Vaultwarden erreichbar sein wird
      DOMAIN = "https://vault.mk-2-home-server.duckdns.org";
      
      # Sicherheit: Registrierungen nach dem Erstellen des ersten Accounts #deaktivieren!
      SIGNUPS_ALLOWED = true; 
      
      # Interner Port, auf dem die App lauscht
      ROCKET_PORT = 8222;
      ROCKET_ADDRESS = "127.0.0.1";
    };
  };

  # ===== Reverse Proxy (Nginx) =====
  # Da der VPS die SSL-Verschlüsselung übernimmt, delegiert Nginx die Anfragen
  # nun unverschlüsselt (HTTP) über Tailscale an Vaultwarden weiter.
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = false;
    recommendedGzipSettings = true;

    virtualHosts."vault.mk-2-home-server.duckdns.org" = {
      # Kein SSL mehr lokal, der VPS-Tunnel übernimmt Let's Encrypt
      locations."/" = {
        proxyPass = "http://127.0.0.1:8222";
      };
    };
  };

  # ===== Firewall =====
  # Port 80/443 für den Webserver freigeben, aber NUR im Tailscale-Netzwerk
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 80 443 ];
}