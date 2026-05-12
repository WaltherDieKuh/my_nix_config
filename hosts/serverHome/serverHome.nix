# hosts/serverHome/serverHome.nix
{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../../modules/adguard.nix
    ../../modules/vaultwarden.nix
    ../../modules/nextcloud.nix
    #../../modules/backup.nix
  ];

  # ===== System / Netzwerk =====
  networking.hostName = "serverHome";

  networking.useDHCP = false;

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  networking.defaultGateway = "192.168.0.1";

  networking.interfaces."enp2s0".ipv4.addresses = [ {
    address = "192.168.0.250"; # Deine Wunscharadresse
    prefixLength = 24;
  } ];
  
  # Variante 1: DHCP mit statischer IP-Reservierung im Router (Empfohlen für Heimnetze wie FritzBox).
  # Belasse networkmanager an, wenn er für WLAN oder einfaches DHCP genutzt wird:
  networking.networkmanager.enable = true; 

  # Variante 2: Manuelle statische IP für Ethernet (z.B. eth0 oder enp3s0 etc.) in NixOS.
  # Beachte: Für LAN-Server ist networkd oft passender als networkmanager, aber wir 
  # halten es hier einfach und zeigen die statische Konfiguration übers network-System:
  # networking.interfaces.enp3s0.ipv4.addresses = [{
  #  address = "192.168.178.10";
  #  prefixLength = 24;
  # }];
  # networking.defaultGateway = "192.168.178.1";
  # networking.nameservers = [ "1.1.1.1" ]; 

  # Setze die Zeitzone und Tastaturlayout
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  # ===== Hardware / Energieverwaltung (Alter Laptop) =====
  # Das Display der Konsole nach 60 Sekunden Inaktivität abschalten (Strom sparen & Burn-In verhindern)
  boot.kernelParams = [ "consoleblank=60" ];

  # Verhindert, dass der Laptop beim Zuklappen in den Sleep geht
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  services.upower.enable = true;

  # Deaktiviert Suspend, Hibernate und Sleep radikal auf Systemebene.
  # (Verhindert zuverlässig, dass irgendein Dämon oder WLAN-Event den Laptop schlafen legt)
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Falls der Server über WLAN verbunden ist: WLAN-Energiesparmodus deaktivieren, 
  # da dieser manchmal für SSH-Verbindungsabbrüche sorgt, wenn der Deckel zu ist
  networking.networkmanager.wifi.powersave = false;

  # ===== SSH Zugang =====
  services.openssh = {
    enable = true;
    # Erhöhe die Sicherheit deines Servers: Root-Login und Passwörter verbieten
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # ===== VPN / Tailscale =====
  services.tailscale = {
    enable = true;
    # Optional: Für den Login ohne Browser. Den Key erstellst du im Tailscale Admin-Panel.
    # Lege den Key auf dem Server einfach in eine Datei (z.B. /root/tailscale_key)
    # und entferne das "#" vor der nächsten Zeile:
    # authKeyFile = "/root/tailscale_key";
  };

  programs.nix-ld.enable = true;

  # ===== Benutzer: server =====
  users.users.server = {
    isNormalUser = true;
    description = "Server Administrator";
    # wheel = sudo-Rechte, networkmanager = Netzwerkeinstellungen
    extraGroups = [ "networkmanager" "wheel" ];

    hashedPassword = "$6$mJmxeYaNOOVRKcFO$2ou.1jwM.kcBoxMiv324OEujNhaw7kxirkkbyjcrjNfM6a3vsbNjJgbw.twAddlVZBD1qgOGdZE4O.PnW1HFp/";
    
    # Füge hier deinen öffentlichen SSH-Key ein (z.B. ~/.ssh/id_rsa.pub vom homePC/laptopUni)
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXgfvt8Z4c6Qvle+vJMn3XhbMi36mHflyBPAOlyWZC+ willi@laptopUni"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAD61iQwFwpiyzfB0NaDH7dLyQfdl8hjiefy5udw20xW willi@WillisPC"    
      ];
  };
  users.users.nginx.extraGroups = [ "acme" "nextcloud" ];

  # Erlaube dem User "server" sudo ohne Passwort (Optional, aber oft bei Servern gewünscht)
  security.sudo.wheelNeedsPassword = false;

  # ===== Grundlegende System-Pakete =====
  environment.systemPackages = with pkgs; [
    git
    git-lfs
    htop
    curl
    wget
    vim
    nano
    powertop
    upower
    tmux       # Nützlich, um Prozesse auch nach SSH-Disconnect am Leben zu halten
    apacheHttpd # Stellt das htpasswd-Tool zur Verfügung
  ];

  # Nötig für Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.loader = {
    # Aktiviert systemd-boot
    systemd-boot.enable = true;

    # Erlaubt es dem Bootloader, das EFI-Variablen-Verzeichnis zu ändern
    # (notwendig für die Installation/Updates)
    efi.canTouchEfiVariables = true;

    # Optional: Begrenzung der Anzahl der Generationen im Boot-Menü
    # Verhindert, dass die EFI-Partition mit alten Einträgen vollgepackt wird
    systemd-boot.configurationLimit = 10;
  };

  # Version (Entspricht dem Release, mit dem du startest)
  system.stateVersion = "23.11"; # Passe das ggf. auf deine aktuelle Version an (z.B. 24.05)

  # ===== Home-Manager (User: server) =====
  # Wir importieren die Auslagerungsdatei aus home/server.nix,
  # um dort alle userspezifischen Aliases und Profile zentral zu verwalten,
  # genau wie bei deinem willi.nix Profil.
  home-manager.users.server = import ../../home/server.nix;

  # ===== Nginx VirtualHost für Website lol =====
  # Da Nginx bereits auf dem Homeserver durch andere Module aktiviert ist,
  # fügen wir hier den VirtualHost hinzu.

  services.nginx.virtualHosts."sophies-dreamworld.de" = {
    # Root-Verzeichnis für Nginx
    root = "/var/www/portfolio";

    basicAuthFile = "/etc/nginx/.htpasswd";

    locations."/media/" = {
      alias = "/var/lib/nextcloud/data/Sophie/files/portfolio-media/";
    };
    
    # SSL wird nicht lokal benötigt, da der VPS (Caddy) dies übernimmt
    listen = [
      {
        addr = "0.0.0.0";
        port = 80;
      }
      {
        addr = "[::]";
        port = 80;
      }
    ];
  };

  # GitHub Runner Dienst konfigurieren
  services.github-runners."portfolio-runner" = {
    enable = true;
    name = "portfolio-runner";
    url = "https://github.com/WaltherDieKuh/sophie-web";
    tokenFile = "/root/secrets/runner-token"; # Muss manuell mit dem GitHub-Token erstellt werden
    extraLabels = [ "nixos-portfolio" ];

    extraPackages = [ pkgs.git pkgs.rsync pkgs.git-lfs ];
  };

  systemd.services."github-runner-portfolio-runner".serviceConfig = {
    ReadWritePaths = [ "/var/www/portfolio" ];
  };

  # Zielordner erstellen und Berechtigungen setzen
  # Der erstellte User für den Runner heißt standardmäßig "github-runner-<runner-name>"
  systemd.tmpfiles.rules = [
    # Typ Pfad Modus User Group Age Argument
    "d /var/www/portfolio 0750 github-runner-portfolio-runner nginx - -"
  ];

  # 1. Der Fließband-Arbeiter (Das Skript)
  systemd.services.portfolio-image-sync = {
    description = "Sync and convert Portfolio Images from Nextcloud";
    # Diese Pakete braucht das Skript zum Arbeiten
    path = [ pkgs.rsync pkgs.libwebp pkgs.coreutils pkgs.findutils ];
    
    script = ''
      # Der interne Pfad, wo Nextcloud die Dateien auf der Festplatte speichert
      NC_DIR="/var/lib/nextcloud/data/Sophie/files/portfolio-media" 
      # Der Ordner, wo die fertigen Bilder für die Website landen sollen
      WEB_DIR="/var/www/portfolio/media"
      # -------------------------------

      # Erstelle den Ordner, falls er noch nicht existiert
      mkdir -p "$WEB_DIR"

      # Schritt 1: Neue Bilder von Nextcloud in den Web-Ordner kopieren
      rsync -a --include="*.jpg" --include="*.jpeg" --include="*.png" --include="*.JPG" --include="*.PNG" --exclude="*" "$NC_DIR/" "$WEB_DIR/"

      # Schritt 2: Bilder im Web-Ordner in WebP umwandeln
      find "$WEB_DIR" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png \) | while read file; do
        webp_file="''${file%.*}.webp"
        
        # Nur konvertieren, wenn wir das nicht schon beim letzten Mal gemacht haben (spart CPU!)
        if [ ! -f "$webp_file" ]; then
          cwebp -quiet -q 80 "$file" -o "$webp_file"
        fi
        
        # Die dicke JPG/PNG-Kopie aus dem Web-Ordner löschen (das Nextcloud-Original bleibt sicher!)
        rm "$file"
      done

      # Schritt 3: Den Magic-Befehl für die Nginx-Rechte ausführen
      chown -R github-runner-portfolio-runner:nginx /var/www/portfolio
      find /var/www/portfolio -type d -exec chmod 755 {} +
      find /var/www/portfolio -type f -exec chmod 644 {} +
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root"; # Braucht Root-Rechte, um in den Nextcloud-Datenordner zu gucken
    };
  };

  # 2. Die Zeitschaltuhr (Läuft jede Minute)
  systemd.timers.portfolio-image-sync = {
    description = "Timer for Portfolio Image Sync";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "1m"; # Intervall: 1 Minute
      Unit = "portfolio-image-sync.service";
    };
  };
}
