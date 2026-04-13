{ config, pkgs, ... }:

{
  # ===== Vaultwarden (Bitwarden Server) =====
  services.vaultwarden = {
    enable = true;
    # Automatisches Backup-Verzeichnis aktivieren
    backupDir = "/var/backup/vaultwarden";
    
    config = {
      # Die URL, unter der Vaultwarden erreichbar sein wird
      DOMAIN = "https://vault.deine-domain.duckdns.org"; # BITTE ANPASSEN
      
      # Sicherheit: Registrierungen nach dem Erstellen des ersten Accounts deaktivieren!
      SIGNUPS_ALLOWED = true; 
      
      # Interner Port, auf dem die App lauscht
      ROCKET_PORT = 8222;
      ROCKET_ADDRESS = "127.0.0.1";
    };
  };

  # ===== Let's Encrypt (ACME) via DNS Challenge =====
  # Da der Server nicht aus dem Internet per Port 80 erreichbar ist, 
  # müssen wir die DNS-01 Challenge nutzen, um ein valides HTTPS-Zertifikat zu bekommen.
  security.acme = {
    acceptTerms = true;
    defaults.email = "deine@email.de"; # BITTE ANPASSEN

    certs."vault.deine-domain.duckdns.org" = {
      domain = "vault.deine-domain.duckdns.org"; # BITTE ANPASSEN
      dnsProvider = "duckdns";
      # Diese Datei musst du NACH dem Deployment manuell erstellen.
      # Sie muss enthalten: DUCKDNS_TOKEN=dein-duckdns-token
      # sudo mkdir -p /var/lib/secrets
      # sudo nano /var/lib/secrets/duckdns.env
      # sudo chmod 400 /var/lib/secrets/duckdns.env
      credentialsFile = "/var/lib/secrets/duckdns.env";
    };
  };

  # ===== Reverse Proxy (Nginx) =====
  # Ich habe hier Nginx gewählt, da es in NixOS extrem reibungslos mit
  # dem internen `security.acme` DNS-Challenge Tool (Lego) zusammenarbeitet.
  # Caddy benötigt für DNS-Challenges oft Custom-Builds mit speziellen Plugins.
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;

    virtualHosts."vault.deine-domain.duckdns.org" = {
      # Zertifikat aus dem ACME Modul von oben verwenden
      useACMEHost = "vault.deine-domain.duckdns.org"; # BITTE ANPASSEN
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8222";
      };
    };
  };

  # ===== Firewall =====
  # Port 80/443 für den Webserver freigeben
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
