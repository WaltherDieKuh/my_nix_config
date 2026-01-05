{...}: {
  programs.hyprpanel = {
    enable = true;
    settings = {
      "theme.font.name" = "Monocraft Nerd Font";
      "theme.font.label" = "Monocraft Nerd Font Ultra-Light";
      "bar.launcher.autoDetectIcon" = true;
      "theme.bar.floating" = true;
      "bar.autoHide" = "fullscreen";
      "theme.bar.border.location" = "none";

      "bar.layouts" = {
        "0" = {
          left = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          middle = [
            "clock"
          ];
          right = [
            "volume"
            "network"
            "bluetooth"
            "battery"
            "systray"
            "media"
            "notifications"
          ];
        };
        "1" = {
          left = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          middle = [
            "media"
          ];
          right = [
            "volume"
            "clock"
            "notifications"
          ];
        };
        "2" = {
          left = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          middle = [
            "media"
          ];
          right = [
            "volume"
            "clock"
            "notifications"
          ];
        };
      };

      menus.media.hideAuthor = false;
      menus.media.hideAlbum = true;
      menus.media.displayTime = true;
      menus.clock.time.military = true;
      menus.clock.weather.location = "Eisenach";
      menus.clock.weather.key = "weatherapi";
      menus.clock.weather.unit = "metric";
      menus.dashboard.shortcuts.left.shortcut1.command = "firefox";
      menus.dashboard.shortcuts.left.shortcut1.tooltip = "Firefox";
      menus.dashboard.shortcuts.left.shortcut3.command = "vesktop";
      menus.dashboard.directories.enabled = false;
      menus.power.lowBatteryThreshold = 10;
      menus.power.lowBatteryNotification = true;
    };
  };
}
