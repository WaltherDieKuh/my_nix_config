# user configuration
{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    firefox
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";
}
