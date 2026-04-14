#{ config, pkgs, ... }:
#
#{
#  # NixOS bietet einen eingebauten Service, um regelmäßig Dumps von #Postgres-Datenbanken zu ziehen.
#  # ===== 1. PostgreSQL Datenbank-Backup =====
#  # (Standardmäßig täglich nachts um 01:15 Uhr)
#  services.postgresqlBackup = {
#    enable = true;
#    databases = [ "nextcloud" ];
#    location = "/var/backup/postgresql"; 
#  };
#
#  # ===== 2. BorgBackup =====
#  services.borgbackup.jobs = {
#    # Wir nennen den Job "localBackup"
#    localBackup = {
#      # Zielverzeichnis auf der externen Festplatte
#      # WICHTIG: Die Festplatte muss vorab nach /mnt/backup gemountet sein #(z.B. via fileSystems in hardware-configuration.nix)
#      repo = "/mnt/backup/borg";
#
#      # Verschlüsselung: "none", "repokey", oder "keyfile"
#      # Für eine lokale (ggf. physisch sichere) Festplatte belassen wir es #hier einfach auf unverschlüsselt (none).
#      # Wenn du sie verschlüsseln möchtest, nutze "repokey" und #konfiguriere eine environment.BORG_PASSPHRASE
#      encryption.mode = "none";
#
#      # Was soll gesichert werden?
#      paths = [
#        # Nextcloud: Die reinen Daten
#        "/var/lib/nextcloud"
#        
#        # Nextcloud: Der gerade von postgresqlBackup erstellte DB-Dump
#        "/var/backup/postgresql"
#        
#        # Vaultwarden: Das autom. SQLite Backup (Datenbank)
#        "/var/backup/vaultwarden"
#        # Vaultwarden: Anhänge etc. (falls genutzt)
#        "/var/lib/vaultwarden"
#        
#        # AdGuard Home: Einstellungen und Statistiken
#        "/var/lib/AdGuardHome"
#      ];
#
#      # Optional: Dinge, die wir NICHT brauchen
#      exclude = [
#        # "/var/lib/nextcloud/data/updater-*" 
#      ];
#
#      # Wann soll das Backup laufen? Täglich um 02:00 Uhr, kurz NACHDEM der #postgres-Dump durch ist
#      startAt = "*-*-* 02:00:00"; 
#
#      # Aufbewahrungsrichtlinien - alte Backups automatisch löschen
#      prune.keep = {
#        within = "1d";  # Behalte alle Backups des letzten Tages
#        daily = 7;      # Behalte 7 tägige Backups
#        weekly = 4;     # Behalte 4 wöchentliche Backups
#        monthly = 6;    # Behalte 6 monatliche Backups
#      };
#
#      # Stelle sicher, dass Borg bei der ersten Ausführung das Repo #initialisiert (falls leer)
#      doInit = true;
#    };
#  };
#
#  # Abhängigkeit: Borg soll bevorzugt erst laufen, wenn postgresqlBackup #fertig ist
#  systemd.services."borgbackup-job-localBackup" = {
#    after = [ "postgresqlBackup.service" ];
#  };
#}
