{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = ["clock"];
        modules-right = [
          "tray"
          "pulseaudio"
          "battery"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
        };

        "hyprland/window" = {
          "max-length" = 35;
          "separate-outputs" = true;
        };

        clock = {
          format = "{:%H:%M}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        pulseaudio = {
          format = "{volume} {icon}";
          "format-muted" = "";
          "format-icons" = {
            default = [
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          "format-charging" = "{capacity}% 󰂄";
          "format-plugged" = "{capacity}% ";
          "format-icons" = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };

        tray = {
          "icon-size" = 18;
          spacing = 10;
        };
      };
    };
    style = builtins.readFile ./waybar.css;
  };
}
