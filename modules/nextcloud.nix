{ config, pkgs, ... }:

{
  # ===== PostgreSQL Datenbank-Backend =====
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  # Dies stellt sicher, dass PostgreSQL hochgefahren ist,
  # bevor Nextcloud konfiguriert wird.
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  # ===== Redis Caching =====
  services.redis.servers.nextcloud = {
    enable = true;
    bind = "127.0.0.1";
    port = 6379;
  };

  # ===== Nextcloud Service =====
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;

    maxUploadSize = "10G";
    
    # PHP etwas mehr RAM geben für flüssigeres Laden von Fotogalerien
    
    # Hostname (wichtig für Reverse Proxy)
    hostName = "mk-2-home-server.duckdns.org"; 

    # Datenverzeichnis (Standard)
    datadir = "/var/lib/nextcloud";

    # SSL wird jetzt extern vom VPS erledigt
    https = false;
    
    # Redis Cache Konfiguration
    configureRedis = true;

    config = {
      # Datenbank Setup: Die Parameter müssen mit PostgreSQL oben matchen.
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql"; # Empfohlen über Unix-Socket

      # Admin User Setup
      adminuser = "admin";
      # Das Passwort liest NixOS aus einer lokalen Datei, statt sie im Nix #Store abzulegen.
      # Bitte manuell erstellen VOR dem ersten Setup (siehe Anleitung am #Ende).
      adminpassFile = "/var/secrets/nextcloud-admin-pass";
    };
    
    # Der VPS über Tailscale dient als vertrauenswürdiger Proxy
    settings = {
      trusted_proxies = [ "100.64.0.0/10" ];
      trusted_domains = [
        "mk-2-home-server.duckdns.org"
        "nextcloud.mk-2-home-server.duckdns.org"
      ];
      overwriteprotocol = "https"; # Damit Nextcloud URLs standardmäßig mit https generiert
    };

    # Nützliche Apps installieren (optional)
    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        contacts calendar tasks;
    };
  };

  # ===== Webserver / Reverse Proxy (Nginx) =====
  services.nginx = {
    enable = true;
    # NixOS konfiguriert Nginx automatisch für Nextcloud (HTTP auf Port 80)
    # da services.nextcloud.https = false gesetzt ist.
  };
}
