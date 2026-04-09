{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable = true;
    font = "Monocraft 14";
    theme = let
      # Define some nice colors (TokyoNight inspired matching your system)
      bg0 = "#1a1b26E6"; # semi-transparent
      bg1 = "#24283b";
      bg2 = "#292e42";
      fg0 = "#c0caf5";
      fg1 = "#a9b1d6";
      fg2 = "#7aa2f7";
      accent = "#7aa2f7";
      urgent = "#f7768e";
    in {
      "*" = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "${fg0}";
        margin = 0;
        padding = 0;
        spacing = 0;
      };

      "window" = {
        background-color = mkLiteral "${bg0}";
        border = mkLiteral "2px";
        border-color = mkLiteral "${accent}";
        border-radius = mkLiteral "12px";
        width = mkLiteral "600px";
        padding = mkLiteral "20px";
      };

      "inputbar" = {
        background-color = mkLiteral "${bg1}";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "12px 16px";
        spacing = mkLiteral "12px";
        children = mkLiteral "[ prompt, entry ]";
      };

      "prompt" = {
        text-color = mkLiteral "${accent}";
        font = "JetBrainsMono Nerd Font Bold 14";
      };

      "entry" = {
        placeholder = "Search...";
        placeholder-color = mkLiteral "${fg1}";
      };

      "listview" = {
        margin = mkLiteral "16px 0 0 0";
        lines = 6;
        columns = 1;
        fixed-height = false;
      };

      "element" = {
        padding = mkLiteral "10px 16px";
        spacing = mkLiteral "16px";
        border-radius = mkLiteral "8px";
      };

      "element normal active" = {
        text-color = mkLiteral "${accent}";
      };

      "element selected normal" = {
        background-color = mkLiteral "${bg2}";
        text-color = mkLiteral "${accent}";
      };

      "element selected active" = {
        background-color = mkLiteral "${bg2}";
        text-color = mkLiteral "${accent}";
      };

      "element-icon" = {
        size = mkLiteral "1.2em";
        vertical-align = mkLiteral "0.5";
      };

      "element-text" = {
        vertical-align = mkLiteral "0.5";
      };
    };
  };
}
