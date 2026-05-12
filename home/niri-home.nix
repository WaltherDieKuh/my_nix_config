{ config, pkgs, lib, ... }:
{
  # Niri user config (moved out of willi.nix to keep it tidy)
  xdg.configFile."niri/config.kdl".text = ''
    // Niri config (KDL)
    input {
      keyboard {
        xkb {
          layout "de"
          variant "nodeadkeys"
        }
      }

      touchpad {
      }

      mouse {
        accel-profile "flat"
      }
    }

    layout {
      gaps 5
      default-column-width { proportion 0.5; }

      border {
        on
        width 2
        active-color "#cba6f7"
        inactive-color "#595959"
      }
    }

    spawn-at-startup "waybar"
    spawn-at-startup "bash" "-c" "$HOME/.config/niri/scripts/set_random_wallpaper.sh"
    spawn-at-startup "nextcloud" "--background"

    window-rule {
      geometry-corner-radius 10
      clip-to-geometry true
      opacity 0.85
      draw-border-with-background false
    }

    window-rule {
      match app-id=r#"fl64\\.exe"#
      open-floating true
      opacity 1.0
    }

    window-rule {
      match app-id="pavucontrol"
      open-floating true
    }

    window-rule {
      match app-id="nm-connection-editor"
      open-floating true
    }

    binds {
      Mod+T { spawn "kitty"; }
      Mod+Q { close-window; }
      Mod+M { quit; }
      Mod+E { spawn "nautilus"; }
      Mod+Space { spawn "rofi" "-show" "drun"; }
      Mod+F { spawn "firefox"; }
      Mod+D { spawn "emote"; }

      Mod+V { toggle-window-floating; }

      Mod+Left  { focus-column-left; }
      Mod+Right { focus-column-right; }
      Mod+Up    { focus-window-up; }
      Mod+Down  { focus-window-down; }

      Mod+1 { focus-workspace 1; }
      Mod+2 { focus-workspace 2; }
      Mod+3 { focus-workspace 3; }
      Mod+4 { focus-workspace 4; }
      Mod+5 { focus-workspace 5; }
      Mod+6 { focus-workspace 6; }
      Mod+7 { focus-workspace 7; }
      Mod+8 { focus-workspace 8; }
      Mod+9 { focus-workspace 9; }

      Mod+Ctrl+1 { move-column-to-workspace 1; }
      Mod+Ctrl+2 { move-column-to-workspace 2; }
      Mod+Ctrl+3 { move-column-to-workspace 3; }
      Mod+Ctrl+4 { move-column-to-workspace 4; }
      Mod+Ctrl+5 { move-column-to-workspace 5; }
      Mod+Ctrl+6 { move-column-to-workspace 6; }
      Mod+Ctrl+7 { move-column-to-workspace 7; }
      Mod+Ctrl+8 { move-column-to-workspace 8; }
      Mod+Ctrl+9 { move-column-to-workspace 9; }

      Mod+WheelScrollDown cooldown-ms=150 { focus-workspace-down; }
      Mod+WheelScrollUp   cooldown-ms=150 { focus-workspace-up; }

      XF86AudioMute         allow-when-locked=true { spawn "swayosd-client" "--output-volume" "mute-toggle"; }
      XF86AudioMicMute      allow-when-locked=true { spawn "swayosd-client" "--input-volume" "mute-toggle"; }
      XF86AudioRaiseVolume  allow-when-locked=true { spawn "swayosd-client" "--output-volume" "raise"; }
      XF86AudioLowerVolume  allow-when-locked=true { spawn "swayosd-client" "--output-volume" "lower"; }
      XF86MonBrightnessUp   allow-when-locked=true { spawn "swayosd-client" "--brightness" "raise"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "swayosd-client" "--brightness" "lower"; }

      Print { spawn "bash" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }
    }
  '';

}
