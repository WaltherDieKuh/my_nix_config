{
  config,
  pkgs,
  lib,
  isDesktop, # Von specialArgs aus der flake.nix geerbt
  isLaptop,  # Von specialArgs aus der flake.nix geerbt
  ...
}: {
  services.swayosd.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Allgemeine Base-Konfiguration, die FÜR BEIDE gilt:
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

      # Monitor configuration
      monitor = ",preferred,auto,1";

      ecosystem.no_update_news = true;

      # Input configuration
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        kb_model = "";
        kb_options = "";
        kb_rules = "";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        allow_tearing = false;
      };

      # Decoration
      decoration = {
        rounding = 10;
        active_opacity = 0.85;
        inactive_opacity = 0.85;
        fullscreen_opacity = 1.00;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      # Animations
      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # Layouts
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Misc
      misc = {
        force_default_wallpaper = -1;
      };

      # Key bindings
      "$mod" = "SUPER";

      bind = [
        # Application shortcuts
        "$mod, T, exec, kitty"

        "$mod, Q, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, nemo"
        "$mod, V, togglefloating,"
        "$mod, Space, exec, rofi -show drun"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        "$mod, F, exec, firefox"
        "$mod, D, exec, emote"

        # Move focus with mod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through existing workspaces with mod + scroll
        "$mod, mouse_down, workspace, e+1"

        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      binde = [
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
      ];


      # Window rules
      windowrule = [
        "match:class fl64.exe, float 1, fullscreen 0, suppress_event fullscreen fullscreenoutput, opacity 1.0 override 1.0 1.0"
        "match:class ^(pavucontrol)$, float 1, stay_focused 1, persistent_size 1, dim_around 1"
        "match:class ^(nm-connection-editor)$, float 1"
      ];

      # Auto-start applications
      exec-once = [
        "waybar"
        "$HOME/.config/hypr/scripts/set_random_wallpaper.sh"
      ];
    };

    # Wir können extraConfig nutzen, um Host-Spezifische Zeilen anzuhängen
    # mit einer if-Abfrage auf isDesktop / isLaptop
    extraConfig = ''
      ${lib.optionalString isDesktop ''
      # === DESKTOP KONFIGURATION ===
      monitor=DP-2, 2560x1440@240, 0x0, 1
      monitor=DP-3, 1920x1080@100, -1920x180, 1
      monitor=HDMI-A-1, 1920x1080@100, 2560x180, 1
      
      device {
        name = wacom-intuos-bt-s-pen
        output = DP-2
      }
      ''}

      ${lib.optionalString isLaptop ''
      # === LAPTOP KONFIGURATION ===
      monitor=eDP-1, preferred, auto, 1
      # (Optional: Skalierung für Laptop)
      # monitor=eDP-1, preferred, auto, 1.25 
      ''}
    '';
  };
}
