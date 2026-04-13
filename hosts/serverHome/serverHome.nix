# hosts/serverHome/serverHome.nix
{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../../modules/adguard.nix
    ../../modules/vaultwarden.nix
    ../../modules/nextcloud.nix
    ../../modules/backup.nix
  ];

  # ===== System / Netzwerk =====
  networking.hostName = "serverHome";
  
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
  # Verhindert, dass der Laptop beim Zuklappen in den Sleep geht
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  # ===== SSH Zugang =====
  services.openssh = {
    enable = true;
    # Erhöhe die Sicherheit deines Servers: Root-Login und Passwörter verbieten
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # ===== Benutzer: server =====
  users.users.server = {
    isNormalUser = true;
    description = "Server Administrator";
    # wheel = sudo-Rechte, networkmanager = Netzwerkeinstellungen
    extraGroups = [ "networkmanager" "wheel" ];
    
    # Füge hier deinen öffentlichen SSH-Key ein (z.B. ~/.ssh/id_rsa.pub vom homePC/laptopUni)
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI...dein-public-key... user@homePC"
    ];
  };

  # Erlaube dem User "server" sudo ohne Passwort (Optional, aber oft bei Servern gewünscht)
  security.sudo.wheelNeedsPassword = false;

  # ===== Grundlegende System-Pakete =====
  environment.systemPackages = with pkgs; [
    git
    htop
    curl
    wget
    vim
    nano
    tmux       # Nützlich, um Prozesse auch nach SSH-Disconnect am Leben zu halten
  ];

  # Nötig für Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Version (Entspricht dem Release, mit dem du startest)
  system.stateVersion = "23.11"; # Passe das ggf. auf deine aktuelle Version an (z.B. 24.05)

  # ===== Home-Manager (User: server) =====
  # Wir importieren die Auslagerungsdatei aus home/server.nix,
  # um dort alle userspezifischen Aliases und Profile zentral zu verwalten,
  # genau wie bei deinem willi.nix Profil.
  home-manager.users.server = import ../../home/server.nix;
}