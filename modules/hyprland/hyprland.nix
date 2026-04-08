{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Monitor configuration
      monitor = ",preferred,auto,1";

      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt5ct"
      ];

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
        gaps_in = 0;
        gaps_out = 0;
        border_size = 0;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        layout = "dwindle";

        allow_tearing = false;
      };

      # Decoration
      decoration = {
        rounding = 0;

        active_opacity = 1.00;
        fullscreen_opacity = 1.00;

        blur = {
          enabled = false;
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
        "$mod, E, exec, nemo"
        "$mod, L, exec, MagicQ"

        "$mod, F, fullscreen" # Super+F -> Echtes Vollbild
        "$mod, M, fullscreen, 1"

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
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      binde = [
        ", XF86MonBrightnessUp, exec, brightnessctl set +5"

        ", XF86MonBrightnessDown, exec, brightnessctl set 5-"
      ];
      # Window rules
      windowrulev2 = [
        "fullscreen, class:^(.*)$"
      ];
      exec-once = [
        "waybar"
        "magicq"
      ];
      misc = {
        disable_hyprland_logo = true; # Deaktiviert das Anime-Logo/Maskottchen
        disable_splash_rendering = true; # Deaktiviert den Text beim Start (spart Ressourcen)
        background_color = "0x000000"; # Hintergrundfarbe (Format: 0xRRGGBB) -> Hier Schwarz
      };
    };
  };
}
