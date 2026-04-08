{
  inputs,
  pkgs,
  lib,
  isHome ? false,
  ...
}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    fonts = {
      serif = {
        package = pkgs.fira;
        name = "Fira Serif";
      };

      sansSerif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };

      monospace = {
        package = pkgs.monocraft;
        name = "Monocraft";
      };

      sizes = {
        applications = 10;
        desktop = 12; # Erhöht für bessere Lesbarkeit in der Waybar
        popups = 10;
        terminal = 10;
      };
    };
    polarity = "dark";
    cursor = {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };
    targets.gtk.enable = true; # Stellt sicher, dass das Cursor-Theme für GTK-Apps gesetzt wird
    targets.hyprland.enable = false;
    targets.vscode.enable = false;
    targets.waybar.enable = false;
    targets.kitty.enable = true;
    targets.firefox.profileNames = ["willi"];
  };
}
