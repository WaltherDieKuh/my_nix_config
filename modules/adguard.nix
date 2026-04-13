{ config, pkgs, ... }:

{
  # Aktiviert den AdGuard Home Service
  services.adguardhome = {
    enable = true;
    
    # Optionen wie Port können hier konfiguriert werden,
    # AdGuard speichert seine Einstellungen aber nach der Ersteinrichtung
    # auch in seiner eigenen YAML in /var/lib/AdGuardHome.
    openFirewall = false; # Wir machen das manuell, um Konflikte zu vermeiden.

    # WICHTIG: Da Nginx (für Vaultwarden/Nextcloud) Port 80 und 443 belegt, 
    # zwingen wir AdGuard hier declarativ auf Port 3000 (auch nach dem Setup).
    settings = {
      http = {
        address = "0.0.0.0:3000";
      };
      dns = {
        bind_hosts = [ "0.0.0.0" ];
        port = 53;
      };
    };
  };

  # === Firewall Einstellungen für AdGuard ===
  networking.firewall = {
    enable = true;

    # DNS (Port 53 TCP und UDP)
    # Webinterface AdGuard (Port 3000 TCP)
    allowedTCPPorts = [ 53 3000 ];
    allowedUDPPorts = [ 53 ];
  };
}
