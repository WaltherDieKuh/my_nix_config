{
  config,
  pkgs,
  lib,
  isDesktop,
  isLaptop,
  ...
}: {
  # Umgebungsvariablen werden separat definiert (für Wayland / Qt)
  home.sessionVariables = {
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # SwayOSD bleibt identisch
  services.swayosd.enable = true;

  programs.niri = {
    enable = true;

    # lib.mkMerge erlaubt uns, Basis-Einstellungen und bedingte
    # Hardware-Konfigurationen (Desktop vs. Laptop) elegant zu kombinieren.
    settings = lib.mkMerge [
      # ==========================================
      # 1. BASIS-KONFIGURATION (Für beide Systeme)
      # ==========================================
      {
        environment = {
          # Niri speichert oft Updates-News, hiermit abschaltbar
          DISPLAY = null; # Platzhalter, falls nötig
        };

        spawn-at-startup = [
          { command = [ "waybar" ]; }
          { command = [ "bash" "-c" "$HOME/.config/niri/scripts/set_random_wallpaper.sh" ]; }
          { command = [ "nextcloud" "--background" ]; }
        ];

        input = {
          keyboard.xkb = {
            layout = "de";
            variant = "nodeadkeys";
          };
          touchpad = {
            natural-scroll = false;
          };
          mouse = {
            accel-profile = "flat";
          };
        };

        layout = {
          # Gaps und Ränder
          gaps = 5; # In Niri gibt es nur einen Gap-Wert zwischen Fenstern

          border = {
            enable = true;
            width = 2;
            # Niri unterstützt aktuell keine Verläufe, wir nehmen die Hauptfarbe
            active.color = "#cba6f7"; 
            inactive.color = "#595959";
          };

          # Fenster-Design
          default-column-width = { proportion = 0.5; };
        };

        # Entspricht 'decoration' in Hyprland
        window-rules = [
          # Allgemeine Opazität (Transparenz)
          {
            geometry-corner-radius = {
              top-left = 10.0;
              top-right = 10.0;
              bottom-left = 10.0;
              bottom-right = 10.0;
            };
            opacity = 0.85;
            draw-border-with-background = false;
          }
          # Spezifische Fenster (Floating & Opacity overrides)
          {
            matches = [ { app-id = "fl64\\.exe"; } ];
            open-floating = true;
            opacity = 1.0;
          }
          {
            matches = [ { app-id = "pavucontrol"; } ];
            open-floating = true;
          }
          {
            matches = [ { app-id = "nm-connection-editor"; } ];
            open-floating = true;
          }
        ];

        # ==========================================
        # KEYBINDS
        # ==========================================
        binds = with config.lib.niri.actions; {
          # Apps öffnen
          "Mod+T".action = spawn "kitty";
          "Mod+Q".action = close-window;
          "Mod+M".action = quit;
          "Mod+E".action = spawn "nautilus";
          "Mod+Space".action = spawn "rofi" "-show" "drun";
          "Mod+F".action = spawn "firefox";
          "Mod+D".action = spawn "emote";

          # Window States
          "Mod+V".action = toggle-window-floating;
          # "Mod+P" (Pseudo) -> Nicht vorhanden in Niri
          # "Mod+J" (Togglesplit) -> Nicht vorhanden in Niri, da Scroll-Layout
          # "Mod+S" (Special Workspace) -> Native Scratchpads fehlen aktuell

          # Fokus bewegen (Pfeiltasten navigieren jetzt durch den "Filmstreifen")
          "Mod+Left".action = focus-column-left;
          "Mod+Right".action = focus-column-right;
          "Mod+Up".action = focus-window-up;
          "Mod+Down".action = focus-window-down;

          # Workspaces wechseln
          "Mod+1".action = focus-workspace 1;
          "Mod+2".action = focus-workspace 2;
          "Mod+3".action = focus-workspace 3;
          "Mod+4".action = focus-workspace 4;
          "Mod+5".action = focus-workspace 5;
          "Mod+6".action = focus-workspace 6;
          "Mod+7".action = focus-workspace 7;
          "Mod+8".action = focus-workspace 8;
          "Mod+9".action = focus-workspace 9;

          # Fenster auf Workspaces verschieben
          "Mod+Shift+1".action = move-column-to-workspace 1;
          "Mod+Shift+2".action = move-column-to-workspace 2;
          "Mod+Shift+3".action = move-column-to-workspace 3;
          "Mod+Shift+4".action = move-column-to-workspace 4;
          "Mod+Shift+5".action = move-column-to-workspace 5;
          "Mod+Shift+6".action = move-column-to-workspace 6;
          "Mod+Shift+7".action = move-column-to-workspace 7;
          "Mod+Shift+8".action = move-column-to-workspace 8;
          "Mod+Shift+9".action = move-column-to-workspace 9;

          # Scroll Workspaces
          "Mod+WheelScrollDown".action = focus-workspace-down;
          "Mod+WheelScrollUp".action = focus-workspace-up;

          # Media & Hardware Keys
          "XF86AudioMute".action = spawn "swayosd-client" "--output-volume" "mute-toggle";
          "XF86AudioMicMute".action = spawn "swayosd-client" "--input-volume" "mute-toggle";
          "XF86AudioRaiseVolume".action = spawn "swayosd-client" "--output-volume" "raise";
          "XF86AudioLowerVolume".action = spawn "swayosd-client" "--output-volume" "lower";
          "XF86MonBrightnessUp".action = spawn "swayosd-client" "--brightness" "raise";
          "XF86MonBrightnessDown".action = spawn "swayosd-client" "--brightness" "lower";

          # Screenshot (Achtung: Niri hat eingebaute Screenshot-Actions, 
          # aber wir können deinen Grim/Slurp Befehl beibehalten)
          "Print".action = spawn "bash" "-c" "grim -g \"$(slurp)\" - | wl-copy";
        };
      }

      # ==========================================
      # 2. DESKTOP SPEZIFISCHE EINSTELLUNGEN
      # ==========================================
      (lib.mkIf isDesktop {
        outputs = {
          "DP-2" = {
            mode = { width = 2560; height = 1440; refresh = 240.0; };
            position = { x = 0; y = 0; };
          };
          "DP-3" = {
            mode = { width = 1920; height = 1080; refresh = 100.0; };
            position = { x = -1920; y = 180; };
          };
          "HDMI-A-1" = {
            mode = { width = 1920; height = 1080; refresh = 100.0; };
            position = { x = 2560; y = 180; };
          };
        };

        # Wacom Tablet an Hauptmonitor binden
        input.tablet.map-to-output = "DP-2";
      })

      # ==========================================
      # 3. LAPTOP SPEZIFISCHE EINSTELLUNGEN
      # ==========================================
      (lib.mkIf isLaptop {
        outputs = {
          "eDP-1" = {
            # Scale kann hier bei Bedarf eingefügt werden: scale = 1.25;
          };
        };

        # Wacom Tablet an Laptop-Bildschirm binden
        input.tablet.map-to-output = "eDP-1";
      })
    ];
  };
}