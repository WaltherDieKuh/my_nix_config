{ pkgs, ... }:

{
  # Java 21 & das Helper-Skript installieren
  environment.systemPackages = with pkgs; [
    jdk21_headless
    
    (writeShellScriptBin "create-mc-server" ''
      #!/usr/bin/env bash
      SERVER_NAME=$1
      JAR_FILE=$2
      BASE_DIR="/home/server/minecraft"

      if [ -z "$SERVER_NAME" ] || [ -z "$JAR_FILE" ]; then
        echo "❌ Fehler! Nutzung: create-mc-server <ServerName> <Pfad-zur-Server.jar>"
        exit 1
      fi

      if [ ! -f "$JAR_FILE" ]; then
        echo "❌ Fehler! Die Datei '$JAR_FILE' wurde nicht gefunden."
        exit 1
      fi

      TARGET_DIR="$BASE_DIR/$SERVER_NAME"

      echo "🧱 Erstelle Minecraft-Server '$SERVER_NAME'..."
      mkdir -p "$TARGET_DIR"
      cp "$JAR_FILE" "$TARGET_DIR/server.jar"
      echo "eula=true" > "$TARGET_DIR/eula.txt"
      
      cat << 'EOF' > "$TARGET_DIR/start.sh"
#!/usr/bin/env bash
cd "$(dirname "$0")"
java -Xms2G -Xmx2G -jar server.jar nogui
EOF
      
      chmod +x "$TARGET_DIR/start.sh"
      
      echo "✅ Fertig! Dein Server liegt in $TARGET_DIR"
      echo "🚀 Starten mit: $TARGET_DIR/start.sh"
    '')
  ];

  # Optional: Erstellt den Basis-Ordner schon beim System-Build mit passenden Rechten
  systemd.tmpfiles.rules = [
    "d /srv/minecraft 0755 root root -"
  ];
}
