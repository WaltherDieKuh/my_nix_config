{ config, pkgs, lib, ... }:
{
  # Niri user config (moved out of willi.nix to keep it tidy)
  xdg.configFile."niri/config.toml".text = ''
    # Generated Niri config (approximate)
    [environment]
    DISPLAY = ""

    [input.keyboard]
    layout = "de"
    variant = "nodeadkeys"

    [layout]
    gaps = 5
    border_enable = true
    border_width = 2
    active_color = "#cba6f7"
    inactive_color = "#595959"

    [appearance]
    # smaller UI font
    font_size = 10

    [spawn]
    waybar = "waybar"
    wallpaper = "$HOME/.config/niri/scripts/set_random_wallpaper.sh"
    nextcloud = "nextcloud --background"

    # Keybindings (Hyprland-style)
    [bindings]
    "Mod+T" = "spawn kitty"
    "Mod+Q" = "close-window"
    "Mod+M" = "quit"
    "Mod+E" = "spawn nautilus"
    "Mod+Space" = "spawn rofi -show drun"
    "Mod+F" = "spawn firefox"
    "Mod+D" = "spawn emote"

    "Mod+V" = "toggle-window-floating"
    "Mod+Left" = "focus-column-left"
    "Mod+Right" = "focus-column-right"
    "Mod+Up" = "focus-window-up"
    "Mod+Down" = "focus-window-down"

    "Mod+1" = "focus-workspace 1"
    "Mod+2" = "focus-workspace 2"
    "Mod+3" = "focus-workspace 3"
    "Mod+4" = "focus-workspace 4"
    "Mod+5" = "focus-workspace 5"
    "Mod+6" = "focus-workspace 6"
    "Mod+7" = "focus-workspace 7"
    "Mod+8" = "focus-workspace 8"
    "Mod+9" = "focus-workspace 9"

    "Mod+Shift+1" = "move-column-to-workspace 1"
    "Mod+Shift+2" = "move-column-to-workspace 2"
    "Mod+Shift+3" = "move-column-to-workspace 3"
    "Mod+Shift+4" = "move-column-to-workspace 4"
    "Mod+Shift+5" = "move-column-to-workspace 5"
    "Mod+Shift+6" = "move-column-to-workspace 6"
    "Mod+Shift+7" = "move-column-to-workspace 7"
    "Mod+Shift+8" = "move-column-to-workspace 8"
    "Mod+Shift+9" = "move-column-to-workspace 9"

    "Mod+WheelScrollDown" = "focus-workspace-down"
    "Mod+WheelScrollUp" = "focus-workspace-up"

    "XF86AudioMute" = "spawn swayosd-client --output-volume mute-toggle"
    "XF86AudioMicMute" = "spawn swayosd-client --input-volume mute-toggle"
    "XF86AudioRaiseVolume" = "spawn swayosd-client --output-volume raise"
    "XF86AudioLowerVolume" = "spawn swayosd-client --output-volume lower"
    "XF86MonBrightnessUp" = "spawn swayosd-client --brightness raise"
    "XF86MonBrightnessDown" = "spawn swayosd-client --brightness lower"

    "Print" = "spawn bash -c 'grim -g \"$(slurp)\" - | wl-copy'"
  '';

  # User systemd units
  systemd.user.services."niri-waybar" = {
    unitConfig = { Description = "Start Waybar for Niri session"; };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.waybar}/bin/waybar";
    };
    install = { wantedBy = [ "default.target" ]; };
  };

  systemd.user.services."niri-nextcloud" = {
    unitConfig = { Description = "Start Nextcloud client"; };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
    };
    install = { wantedBy = [ "default.target" ]; };
  };

}
