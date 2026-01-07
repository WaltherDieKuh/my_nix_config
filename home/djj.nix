# user configuration
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    magicq
    brightnessctl
    wl-clipboard
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  imports = [
    ./aliasse.nix
  ];
}
