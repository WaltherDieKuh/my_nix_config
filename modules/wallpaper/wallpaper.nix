{pkgs, ...}: let
  wallpaperPaths = [
    ./wallpapers/BastiGHG1.jpg
    ./wallpapers/BastiGHG2.jpg
    ./wallpapers/minecraft1.jpg
    ./wallpapers/minecraft2.jpg
  ];
in {
  # Generate wallpaper list for Niri/Wayland
  xdg.configFile."niri/wallpaper.list".text = builtins.concatStringsSep "\n" wallpaperPaths;

  # Script: pick random wallpaper and set with swww (fallback writes path)
  xdg.configFile."niri/scripts/set_random_wallpaper.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash

      WALLPAPER_LIST="$HOME/.config/niri/wallpaper.list"

      if [ ! -f "$WALLPAPER_LIST" ]; then
        exit 1
      fi

      RANDOM_WALLPAPER=$(${pkgs.coreutils}/bin/shuf -n 1 "$WALLPAPER_LIST")

      if [ -x "${pkgs.swww}/bin/swww" ]; then
        ${pkgs.swww}/bin/swww img "$RANDOM_WALLPAPER" --transition-type crossfade --transition-duration 500
      else
        echo "$RANDOM_WALLPAPER" > "$HOME/.cache/current_wallpaper"
      fi
    '';
  };

  # systemd --user service and timer to rotate wallpaper every 30 minutes
  xdg.configFile."systemd/user/niri-random-wallpaper.service" = {
    text = ''
[Unit]
Description=Set random wallpaper for Niri

[Service]
Type=oneshot
ExecStart=${pkgs.bash}/bin/bash $HOME/.config/niri/scripts/set_random_wallpaper.sh
; Ensure service runs in user session
    '';
  };

  xdg.configFile."systemd/user/niri-random-wallpaper.timer" = {
    text = ''
[Unit]
Description=Run niri-random-wallpaper.service periodically

[Timer]
OnBootSec=1min
OnUnitActiveSec=30min
Persistent=true

[Install]
WantedBy=timers.target
    '';
  };
}
