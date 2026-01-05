# user configuration
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    magicq
    firefox
    monocraft
    brightnessctl
    hyprpaper
    wl-clipboard
    jetbrains-toolbox
    helvum
    docker
    tor-browser
    lmms
    hyprpanel
  ];

  home.pointerCursor.hyprcursor.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  imports = [
    ../modules/stylix.nix
    ../modules/stylix-home.nix
    ./aliasse.nix
  ];
}
