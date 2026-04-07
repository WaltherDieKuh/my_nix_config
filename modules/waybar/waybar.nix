{
  config,
  pkgs,
  ...
}: {
  services.swaync.enable = true; # Notification Center Ersatz für Hyprpanel

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin = "8 14 0 14";
        spacing = 10;
        
        modules-left = [
          "custom/launcher"
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [
          "mpris"
        ];
        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "battery"
          "clock"
          "custom/notification"
        ];

        "custom/launcher" = {
          format = " ";
          on-click = "rofi -show drun";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            active = "";
            default = "";
            empty = "";
          };
          persistent-workspaces = {
            "*" = 4;
          };
        };

        "hyprland/window" = {
          max-length = 35;
          separate-outputs = true;
        };

        mpris = {
          format = "{player_icon} {title}";
          format-paused = "{status_icon} <i>{title}</i>";
          player-icons = {
            default = "▶";
            mpv = "🎵";
            spotify = "";
          };
          status-icons = {
            paused = "⏸";
          };
          max-length = 40;
        };

        clock = {
          format = "  {:%H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "   Muted";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };

        network = {
          format-wifi = "   {essid}";
          format-ethernet = "󰈀   Wired";
          format-disconnected = "󰤭   Offline";
          tooltip-format = "{ifname} via {gwaddr}";
          on-click = "nm-connection-editor";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-plugged = "   {capacity}%";
          format-icons = ["󰁺" "󰁽" "󰁿" "󰂁" "󰁹"];
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        "custom/notification" = {
          tooltip = false;
          format = "{icon} ";
          format-icons = {
            notification = " <span foreground='red'><sup></sup></span>";
            none = " ";
            dnd-notification = " <span foreground='red'><sup></sup></span>";
            dnd-none = " ";
            inhibited-notification = " <span foreground='red'><sup></sup></span>";
            inhibited-none = " ";
            dnd-inhibited-notification = " <span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = " ";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };
    };
    style = builtins.readFile ./waybar.css;
  };
}
