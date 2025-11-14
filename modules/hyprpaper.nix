# hyprpaper.nix
{pkgs, ...}: let
  wallpaperPaths = [
    ./wallpapers/BastiGHGZickZackV5.jpg
    ./wallpapers/BastiGHGZickZackV3Wallpaper.jpg
    ./wallpapers/minecraft-wallpaper-skeleton.jpg
    ./wallpapers/itl.cat_wallpaper-de-minecraft-hd_1742082.jpg
  ];
in {
  # 1. hyprpaper Service aktivieren
  services.hyprpaper = {
    enable = true;
  };

  # 2. Wallpaper-Liste generieren
  xdg.configFile."hypr/wallpaper.list".text = builtins.concatStringsSep "\n" wallpaperPaths;

  # 3. Shell-Skript generieren
  xdg.configFile."hypr/scripts/set_random_wallpaper.sh" = {
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash

      WALLPAPER_LIST="$HOME/.config/hypr/wallpaper.list"

      if [ ! -f "$WALLPAPER_LIST" ]; then
        exit 1
      fi

      sleep 1

      RANDOM_WALLPAPER=$(${pkgs.coreutils}/bin/shuf -n 1 "$WALLPAPER_LIST")

      ${pkgs.hyprland}/bin/hyprctl hyprpaper preload "$RANDOM_WALLPAPER"
      ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ", $RANDOM_WALLPAPER"
    '';
  };

  # 4. Skript in Hyprland ausführen
  wayland.windowManager.hyprland.extraConfig = ''
    exec-once = $HOME/.config/hypr/scripts/set_random_wallpaper.sh
  '';
}
