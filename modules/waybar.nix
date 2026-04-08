{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "overlay";
        position = "bottom";
        margin-bottom = 20;
        width = 400;

        modules-center = ["custom/magicq" "custom/keyboard" "custom/reboot"];

        "custom/magicq" = {
          format = "🎮";
          on-click = "restart-magicq";
          tooltip = false;
        };

        "custom/keyboard" = {
          format = "⌨️";
          on-click = "toggle-keyboard";
          tooltip = false;
        };

        "custom/reboot" = {
          format = "🔄";
          on-click = "systemctl reboot";
          tooltip = false;
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrains Mono Nerd Font", sans-serif;
        font-size: 36px;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background-color: transparent;
      }

      .modules-center {
        background-color: rgba(30, 30, 30, 0.85);
        border-radius: 40px;
        padding: 5px 20px;
      }

      #custom-magicq, #custom-keyboard, #custom-reboot {
        color: #ffffff;
        padding: 10px 20px;
        margin: 0 5px;
        border-radius: 30px;
      }

      #custom-magicq:active, #custom-keyboard:active, #custom-reboot:active {
        background-color: rgba(255, 255, 255, 0.2);
      }
    '';
  };
}
