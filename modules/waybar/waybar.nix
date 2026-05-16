{
  config,
  pkgs,
  ...
}:
let
  barConfig = {
    layer = "top";
    position = "top";
    margin = "8 14 0 14";
    spacing = 10;
  };
  commonModules = {
    "custom/launcher" = {
      format = " ";
      on-click = "rofi -show drun";
      tooltip = false;
    };
    "niri/workspaces" = {
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
    "niri/window" = {
      max-length = 35;
      separate-outputs = true;
    };
    mpris = {
      format = "{player_icon}  {artist} - {title}";
      format-paused = "{status_icon} <i>{artist} - {title}</i>";
      player-icons = {
        default = "▶";
        mpv = "🎵";
        spotify = "";
        "spotify-qt" = "";
        spotifyd = "";
      };
      status-icons = {
        paused = "⏸";
      };
      max-length = 50;
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
    bluetooth = {
      format = "  {status}";
      format-connected = "  {device_alias}";
      format-connected-battery = "  {device_alias} {device_battery_percentage}%";
      tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
      tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
      tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
      on-click = "blueman-manager";
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
    cpu = {
      format = "  {usage}%";
      tooltip = false;
    };
    memory = {
      format = "  {}%";
    };
    "custom/gpu" = {
      exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
      format = "󰢮  {}%";
      interval = 1;
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
in {
  services.swaync.enable = true; # Notification Center Ersatz für Hyprpanel

  programs.waybar = {
    enable = true;
    settings = {
      leftBar = barConfig // {
        output = "DP-3";
        modules-left = [
          "custom/launcher"
          "niri/workspaces"
        ];
        modules-center = [ "pulseaudio" ];
        modules-right = [
          "cpu"
          "custom/gpu"
          "memory" 
          ];
      } // commonModules;

      centerBar = barConfig // {
        output = "DP-2";
        modules-left = [
          "custom/launcher"
          "niri/workspaces"
          "niri/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "bluetooth" ];
      } // commonModules;

      rightBar = barConfig // {
        output = "HDMI-A-1";
        modules-left = [
          "custom/launcher"
          "niri/workspaces"
        ];
        modules-center = [ "mpris" ];
        modules-right = [ "pulseaudio" "custom/notification" ];
      } // commonModules;

      laptopBar = barConfig // {
        output = "eDP-1";
        modules-left = [
          "custom/launcher"
          "niri/workspaces"
          "niri/window"
        ];
        modules-center = [ "clock" "mpris" ];
        modules-right = [
          "cpu"
          "memory"
          "tray"
          "pulseaudio"
          "battery"
          "custom/notification"
        ];
      } // commonModules;
    };
    style = builtins.readFile ./waybar.css;
  };
}
