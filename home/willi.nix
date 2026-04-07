# user configuration
{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    magicq
    pavucontrol
    monocraft
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
    fish.enable = true;

    password-store = {
      enable = true;
      # pass-import ist wichtig für den Google-CSV Import!
      package = pkgs.pass.withExtensions (exts: [ exts.pass-import ]);
    };
    
    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-rofi;
  };

  services.playerctld.enable = true;

  home.stateVersion = "25.05";

  imports = [
    ../modules/stylix.nix
    ../modules/stylix-home.nix
    ../modules/rofi/rofi.nix
    ../modules/firefox.nix
    ./aliasse.nix
  ];
}
