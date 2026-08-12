# user configuration
{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    magicq
    qutebrowser
    brightnessctl
    wvkbd
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  imports = [
    ./aliasse.nix
  ];
}
