# user configuration
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    magicq
    pavucontrol
    monocraft
    nerd-fonts.symbols-only
    networkmanagerapplet
    pasystray
    brightnessctl
    # hyprpaper removed (Hyprland-specific)
    wl-clipboard
    swww
    waybar
    nextcloud-client
    jetbrains-toolbox
    docker
    tor-browser
    lmms

    rofi-pass-wayland
    gnupg
  ];

  home.pointerCursor.hyprcursor.enable = true;
  gtk.gtk4.theme = null;

  programs = {
    home-manager.enable = true;
    gemini-cli.enable = true;
    fastfetch.enable = true;
    vscode.enable = true;
    vesktop.enable = true;
    eza.enable = true;
    bat.enable = true;

    fish = {
    enable = true;
    interactiveShellInit = ''
      # Zwingt Fish dazu, runde Ecken korrekt als Breite 1 zu berechnen
      set -g fish_ambiguous_width 1
    '';
    };

    password-store = {
      enable = true;
      # pass-import ist wichtig für den Google-CSV Import!
      package = pkgs.pass.withExtensions (exts: [exts.pass-import]);
      settings = {};
    };

    browserpass = {
      enable = true;
      browsers = ["firefox"];
    };
    direnv = {
    enable = true;
    nix-direnv.enable = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-rofi;
    # Zeit in Sekunden, bis das Passwort nach inaktivität vergessen wird (hier 24 Stunden)
    defaultCacheTtl = 86400;
    # Maximale absolute Zeit in Sekunden, bis das Passwort zwingend neu eingegeben werden muss (hier 3 Tage)
    maxCacheTtl = 259200;
  };

  services.playerctld.enable = true;

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.05";

  # Generate a Niri config file (approximate TOML representation)
  xdg.configFile."niri/config.toml".text = ''
    # Generated Niri config (approximate)
    [environment]
    DISPLAY = ""

    [input.keyboard]
    layout = "de"
    variant = "nodeadkeys"

    [layout]
    gaps = 5
    border_enable = true
    border_width = 2
    active_color = "#cba6f7"
    inactive_color = "#595959"

    [spawn]
    waybar = "waybar"
    wallpaper = "$HOME/.config/niri/scripts/set_random_wallpaper.sh"
    nextcloud = "nextcloud --background"

    # Keybindings (Hyprland-style) — Niri will need corresponding parsing
    [bindings]
    "Mod+T" = "spawn kitty"
    "Mod+Q" = "close-window"
    "Mod+M" = "quit"
    "Mod+E" = "spawn nautilus"
    "Mod+Space" = "spawn rofi -show drun"
    "Mod+F" = "spawn firefox"
    "Mod+D" = "spawn emote"

    "Mod+V" = "toggle-window-floating"
    "Mod+Left" = "focus-column-left"
    "Mod+Right" = "focus-column-right"
    "Mod+Up" = "focus-window-up"
    "Mod+Down" = "focus-window-down"

    "Mod+1" = "focus-workspace 1"
    "Mod+2" = "focus-workspace 2"
    "Mod+3" = "focus-workspace 3"
    "Mod+4" = "focus-workspace 4"
    "Mod+5" = "focus-workspace 5"
    "Mod+6" = "focus-workspace 6"
    "Mod+7" = "focus-workspace 7"
    "Mod+8" = "focus-workspace 8"
    "Mod+9" = "focus-workspace 9"

    "Mod+Shift+1" = "move-column-to-workspace 1"
    "Mod+Shift+2" = "move-column-to-workspace 2"
    "Mod+Shift+3" = "move-column-to-workspace 3"
    "Mod+Shift+4" = "move-column-to-workspace 4"
    "Mod+Shift+5" = "move-column-to-workspace 5"
    "Mod+Shift+6" = "move-column-to-workspace 6"
    "Mod+Shift+7" = "move-column-to-workspace 7"
    "Mod+Shift+8" = "move-column-to-workspace 8"
    "Mod+Shift+9" = "move-column-to-workspace 9"

    "Mod+WheelScrollDown" = "focus-workspace-down"
    "Mod+WheelScrollUp" = "focus-workspace-up"

    "XF86AudioMute" = "spawn swayosd-client --output-volume mute-toggle"
    "XF86AudioMicMute" = "spawn swayosd-client --input-volume mute-toggle"
    "XF86AudioRaiseVolume" = "spawn swayosd-client --output-volume raise"
    "XF86AudioLowerVolume" = "spawn swayosd-client --output-volume lower"
    "XF86MonBrightnessUp" = "spawn swayosd-client --brightness raise"
    "XF86MonBrightnessDown" = "spawn swayosd-client --brightness lower"

    "Print" = "spawn bash -c 'grim -g \"$(slurp)\" - | wl-copy'"
  '';

  # Ensure startup services run in the user session (Waybar, Nextcloud)
  systemd.user.services."niri-waybar" = {
    unitConfig = { Description = "Start Waybar for Niri session"; };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.waybar}/bin/waybar";
    };
    install = { wantedBy = [ "default.target" ]; };
  };

  systemd.user.services."niri-nextcloud" = {
    unitConfig = { Description = "Start Nextcloud client"; };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
    };
    install = { wantedBy = [ "default.target" ]; };
  };

  imports = [
    ../modules/stylix.nix
    ../modules/stylix-home.nix
    ../modules/rofi/rofi.nix
    ../modules/niri.nix
    ../modules/firefox.nix
    ../modules/nautilus.nix
    ../modules/starship.nix
    ../modules/nextcloud-client.nix
    ./aliasse.nix
  ];
}
