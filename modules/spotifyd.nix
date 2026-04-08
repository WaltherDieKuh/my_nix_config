{
  config,
  pkgs,
  ...
}: {
  # Installiert und startet spotifyd automatisch als systemd-Dienst
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        # Ohne festgelegten Benutzernamen/Passwort startet spotifyd im "Discovery Mode" (Zeroconf).
        # Du kannst dann am PC oder Handy den "nixos-willi" als Abspielgerät auswählen.
        # Ab dann merkt er sich das Zertifikat sicher im 'cache_path' und authentifiziert sich künftig selbst!

        # Audioausgabe (meistens pulseaudio oder pipewire/alsa bei NixOS/Wayland)
        backend = "pulseaudio";
        device_name = "nixos-willi";
        bitrate = 320;

        # Lege den Zeroconf Port explizit fest, damit wir ihn in der Firewall (common/default.nix) öffnen können!
        zeroconf_port = 5000;

        # Cache aktivieren für Offline-Playback/schnelleres Laden
        cache_path = "${config.home.homeDirectory}/.cache/spotifyd";
        max_cache_size = 1000000000; # 1GB

        # Wichtig: MPRIS aktivieren, damit es in der Waybar angezeigt wird
        # und du es mit Medientasten (swayosd) steuern kannst.
        use_mpris = true;
      };
    };
  };

  # Dummy .desktop-Eintrag, um den Dienst in Rofi "sehen" und neustarten zu können
  xdg.desktopEntries.spotifyd = {
    name = "Spotify Daemon Restart";
    genericName = "Music Player Daemon";
    icon = "spotify";
    # Ein Klick in Rofi startet den Daemon neu
    exec = "systemctl --user restart spotifyd.service";
    terminal = false;
    categories = ["Audio" "Music"];
  };

  # Bonus: Wenn du spotify durch spotifyd ersetzt, brauchst du einen Client,
  # um Musik zu suchen (abgesehen vom Handy).
  # spotify-qt ist die extrem ressourcenschonende "bare-bones" GUI schlechthin.
  # Beim ersten Start in den Spotify-qt Einstellungen auf deinen Daemon ("nixos-willi") verbinden!
  home.packages = with pkgs; [
    spotify-qt
  ];
}
