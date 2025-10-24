# user configuration
{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    magicq
    firefox
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
