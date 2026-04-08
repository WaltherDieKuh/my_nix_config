# user configuration
{
  config,
  pkgs,
  ...
}: let
  toggleKeyboard = pkgs.writeShellScriptBin "toggle-keyboard" ''
    if pgrep -x wvkbd-mobintl > /dev/null; then
      pkill -x wvkbd-mobintl
    else
      hyprctl dispatch exec "wvkbd-mobintl -L 300"
    fi
  '';

  restartMagicq = pkgs.writeShellScriptBin "restart-magicq" ''
    pkill -x runmagicq.sh || true
    pkill -x magicq || true
    sleep 0.5
    hyprctl dispatch exec magicq
  '';
in {
  home.packages = with pkgs; [
    magicq
    brightnessctl
    wl-clipboard
    wvkbd
    toggleKeyboard
    restartMagicq
  ];

  programs.home-manager.enable = true;

  home.stateVersion = "25.05";

  imports = [
    ./aliasse.nix
    ../modules/waybar.nix
  ];
}
