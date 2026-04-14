#{ config, pkgs, ... }:
#
#{
#  # ===== PostgreSQL Datenbank-Backend =====
#  services.postgresql = {
#    enable = true;
#    # Datenbank und User automatisch anlegen
#    ensureDatabases = [ "nextcloud" ];
#    ensureUsers = [
#      {
#        name = "nextcloud";
#        ensureDBOwnership = true;
#      }
#    ];
#  };
#
#  # Dies stellt sicher, dass PostgreSQL hochgefahren ist,
#  # bevor Nextcloud konfiguriert wird.
#  systemd.services."nextcloud-setup" = {
#    requires = [ "postgresql.service" ];
#    after = [ "postgresql.service" ];
#  };
#
#  # ===== Redis Caching =====
#  services.redis.servers.nextcloud = {
#    enable = true;
#    bind = "127.0.0.1";
#    port = 6379;
#  };
#
#  # ===== Nextcloud Service =====
#  services.nextcloud = {
#    enable = true;
#    package = pkgs.nextcloud; # Nutzt default stable Version (sicherer bei #Upgrades)
#    
#    # Hostname (wichtig für Reverse Proxy & Let's Encrypt)
#    hostName = "nextcloud.deine-domain.duckdns.org"; # BITTE ANPASSEN
#
#    # Datenverzeichnis (Standard)
#    datadir = "/var/lib/nextcloud";
#
#    # SSL wird vom Reverse Proxy (Nginx) erledigt
#    https = true;
#    
#    # Redis Cache Konfiguration
#    configureRedis = true;
#
#    config = {
#      # Datenbank Setup: Die Parameter müssen mit PostgreSQL oben matchen.
#      dbtype = "pgsql";
#      dbname = "nextcloud";
#      dbuser = "nextcloud";
#      dbhost = "/run/postgresql"; # Empfohlen über Unix-Socket
#
#      # Admin User Setup
#      adminuser = "admin";
#      # Das Passwort liest NixOS aus einer lokalen Datei, statt sie im Nix #Store abzulegen.
#      # Bitte manuell erstellen VOR dem ersten Setup (siehe Anleitung am #Ende).
#      adminpassFile = "/var/secrets/nextcloud-admin-pass";
#    };
#
#    # Nützliche Apps installieren (optional)
#    extraAppsEnable = true;
#    extraApps = {
#      inherit (config.services.nextcloud.package.packages.apps)
#        contacts calendar tasks;
#    };
#  };
#
#  # ===== Webserver / Reverse Proxy (Nginx) =====
#  # Wie beim Vaultwarden-Modul verbinden wir Nextcloud mit Nginx und ACME #(Let's Encrypt).
#  # NixOS konfiguriert Nginx automatisch so, dass es perfekt zu Nextcloud #passt, 
#  # sobald `services.nextcloud.hostName` gesetzt ist und Nginx als #Webserver genutzt wird.
#  # (VirtualHost wird automatisch anhand von services.nextcloud.hostName #generiert, 
#  # wir fügen nur ACME DNS-Challenge hinzu).
#  services.nginx = {
#    enable = true;
#    virtualHosts.${config.services.nextcloud.hostName} = {
#      forceSSL = true;
#      # Hier nutzen wir das Zertifikat aus security.acme, das wir ggf. mit #DuckDNS holen
#      useACMEHost = "nextcloud.deine-domain.duckdns.org"; # BITTE ANPASSEN
#    };
#  };
#
#  # Die ACME / Let's Encrypt Config per DuckDNS (wie schon bei #Vaultwarden):
#  security.acme = {
#    acceptTerms = true;
#    # E-Mail-Adresse für Let's Encrypt Benachrichtigungen (auch hier #anpassen!)
#    defaults.email = "deine@email.de"; # BITTE ANPASSEN
#
#    certs."nextcloud.deine-domain.duckdns.org" = {
#      domain = "nextcloud.deine-domain.duckdns.org"; # BITTE ANPASSEN
#      dnsProvider = "duckdns";
#      # Die Datei mit dem Token (DUCKDNS_TOKEN=xxx) muss existieren.
#      credentialsFile = "/var/lib/secrets/duckdns.env";
#    };
#  };
#}
