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
        package = pkgs.fira-code;
        name = "FiraCode Nerd Font Mono"; # or "FiraCode Nerd Font"
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 10;
        desktop = 8;
        popups = 8;
        terminal = 10;
      };
    };
    polarity = "dark";
    cursor = {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };
  };
}
