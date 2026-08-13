{
  pkgs,
  ...
}: let
  swaymsg = "${pkgs.sway}/bin/swaymsg";

  # Browser auf dediziertem Workspace öffnen (exklusives Vollbild neben MagicQ)
  openBrowser = pkgs.writeShellScriptBin "open-browser" ''
    export QTWEBENGINE_DISABLE_SANDBOX=1
    if pgrep -x qutebrowser >/dev/null; then
      ${swaymsg} workspace browser
    else
      ${swaymsg} create_workspace browser
      ${pkgs.qutebrowser}/bin/qutebrowser &
    fi
  '';

  # On-Screen-Tastatur (für den Fall, dass keine Tastatur angeschlossen ist)
  toggleKeyboard = pkgs.writeShellScriptBin "toggle-keyboard" ''
    if pgrep -x wvkbd-mobintl >/dev/null; then
      pkill -x wvkbd-mobintl
    else
      ${pkgs.wvkbd}/bin/wvkbd-mobintl -L 300 &
    fi
  '';

  restartMagicq = pkgs.writeShellScriptBin "restart-magicq" ''
    pkill -x runmagicq.sh 2>/dev/null || true
    pkill -x magicq 2>/dev/null || true
    sleep 0.5
    ${swaymsg} workspace 1
    ${swaymsg} exec magicq
  '';
in {
  # Session-Start: beim Login auf tty1 (getty-Autologin) direkt sway starten
  programs.fish.loginShellInit = ''
    if status is-login; and test (tty) = /dev/tty1; and test -z "$DISPLAY"; and test -z "$WAYLAND_DISPLAY"
      exec sway
    end
  '';

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = false;

    # Config-Check beim Build deaktivieren (schlägt im Sandbox fehl).
    # TODO: sway-Config später manuell prüfen (sway --validate)
    checkConfig = false;

    config = {
      modifier = "Mod4";

      bars = [];

      seat = {
        "*" = {
          hide_cursor = "when-typing enable";
        };
      };

      output = {
        "*" = {
          bg = "#000000 solid_color";
        };
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "de";
          xkb_variant = "nodeadkeys";
        };
      };

      startup = [
        {command = "brightnessctl set 100%";}
        {command = "magicq";}
      ];

      keybindings = {
        "$mod+b" = "exec ${openBrowser}/bin/open-browser";
        "$mod+k" = "exec ${toggleKeyboard}/bin/toggle-keyboard";
        "$mod+m" = "workspace 1";
        "$mod+q" = "kill";
      };
    };

    # Alles immer als exclusive Fullscreen (MagicQ, Browser, ...)
    extraConfig = ''
      for_window [app_id=".*"] fullscreen enable
      for_window [class=".*"] fullscreen enable
    '';
  };

  home.packages = [
    openBrowser
    toggleKeyboard
    restartMagicq
  ];
}
