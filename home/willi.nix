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
  ];

  home.pointerCursor.hyprcursor.enable = true;

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  imports = [
    ../modules/stylix.nix
    ../modules/stylix-home.nix
  ];
}
