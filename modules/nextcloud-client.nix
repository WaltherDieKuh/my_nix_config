{ config, pkgs, ... }:

{
  # Installiere das nextcloud-client Paket
  home.packages = [ pkgs.nextcloud-client ];

  # Wir überlassen den Autostart der Niri-Session (spawn-at-startup) anstatt systemd,
  # da systemd user services unter Wayland manchmal am fehlenden Tray-Target
  # oder graphical-session.target hängen bleiben.
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
  
  # Verunmögliche den automatischen Systemd-Start, da wir exec-once nutzen
  systemd.user.services.nextcloud-client.Install.WantedBy = pkgs.lib.mkForce [];

  # Optionale Vorkonfiguration (Nextcloud GUI)
  # Da Nextcloud Schreibrechte auf die Datei benötigt, um Tokens und aktuellen Status
  # zu speichern, erstellen wir die Config-Datei beim Start, statt einen
  # read-only Symlink in den Nix-Store (xdg.configFile) zu setzen.
  home.activation.setupNextcloudSession = config.lib.dag.entryAfter ["writeBoundary"] ''
    mkdir -p /home/willi/.config/Nextcloud
    
    # Erstelle die Datei nur neu, falls sie noch nicht existiert, um
    # Logins/Tokens nicht bei jedem Switch zu überschreiben.
    if [ ! -f /home/willi/.config/Nextcloud/nextcloud.cfg ]; then
      cat > /home/willi/.config/Nextcloud/nextcloud.cfg << 'EOF'
[General]
clientVersion=3.12.0

[Accounts]
0\Accounts\id=wilhelm.woelkner@gmail.com
0\Accounts\serverVersion=30.0.0
0\Accounts\url=https://nextcloud.mk-2-home-server.duckdns.org
0\Accounts\webflow_user=wilhelm.woelkner@gmail.com
# Standard-Sync Verzeichnis konfigurieren
0\Folders\1\localPath=/home/willi/Meine_Dateien/
0\Folders\1\targetPath=/Meine_Dateien
0\Folders\1\paused=false
version=2
EOF
      chmod 600 /home/willi/.config/Nextcloud/nextcloud.cfg
    fi
  '';

  # Erstelle das lokale Verzeichnis, falls es nicht existiert
  home.activation.createNextcloudDir = config.lib.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p /home/willi/Meine_Dateien
  '';
}
