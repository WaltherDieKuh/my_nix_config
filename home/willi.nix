# user configuration
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    magicq
    firefox
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
  ];

  home.pointerCursor.hyprcursor.enable = true;

  programs = {
    home-manager.enable = true;
    gemini-cli.enable = true;
    fastfetch.enable = true;
    vscode.enable = true;
    rofi.enable = true;
    vesktop.enable = true;
    fish.enable = true;
  };

  home.stateVersion = "25.05";

  imports = [
    ../modules/stylix.nix
    ../modules/stylix-home.nix
    ./aliasse.nix
  ];
}
