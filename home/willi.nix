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
    hyprpaper
    wl-clipboard
    jetbrains-toolbox
    crosspipe
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

  imports = [
    ../modules/stylix.nix
    ../modules/stylix-home.nix
    ../modules/rofi/rofi.nix
    ../modules/firefox.nix
    ../modules/nautilus.nix
    ../modules/starship.nix
    ../modules/nextcloud-client.nix
    ./aliasse.nix
  ];
}
