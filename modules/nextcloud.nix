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
    
    # Hostname (wichtig für Reverse Proxy & Let's Encrypt)
    hostName = "nextcloud.mk-2-home-server.duckdns.org"; # BITTE ANPASSEN

    # Datenverzeichnis (Standard)
    datadir = "/var/lib/nextcloud";

    # SSL wird vom Reverse Proxy (Nginx) erledigt
    https = true;
    
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

    # Nützliche Apps installieren (optional)
    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        contacts calendar tasks;
    };
  };

  # ===== Webserver / Reverse Proxy (Nginx) =====
  # Wie beim Vaultwarden-Modul verbinden wir Nextcloud mit Nginx und ACME #(Let's Encrypt).
  # NixOS konfiguriert Nginx automatisch so, dass es perfekt zu Nextcloud #passt, 
  # sobald `services.nextcloud.hostName` gesetzt ist und Nginx als #Webserver genutzt wird.
  # (VirtualHost wird automatisch anhand von services.nextcloud.hostName #generiert, 
  # wir fügen nur ACME DNS-Challenge hinzu).
  services.nginx = {
    enable = true;
    virtualHosts.${config.services.nextcloud.hostName} = {
      forceSSL = true;
      useACMEHost = "nextcloud.mk-2-home-server.duckdns.org";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "wilhelm.woelkner@gmail.com"; 

    certs."nextcloud.mk-2-home-server.duckdns.org" = {
      group = config.services.nginx.group;
      domain = "nextcloud.mk-2-home-server.duckdns.org"; 
      dnsProvider = "duckdns";
      credentialsFile = "/var/lib/secrets/duckdns.env";
    };
  };
}
