#Das ist meine hosts/laptopUni.nix 

{ config, pkgs, ...}: {
  imports = [];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptopUni";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  # Localization settings for Germany
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  # Set keyboard layout for Wayland
  environment.variables = {
    XKB_DEFAULT_LAYOUT = "de";
    XKB_DEFAULT_VARIANT = "nodeadkeys";
  };

  users.users.willi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    neovim
  ];

  services.xserver.enable = false;
  services.displayManager.enable = false;

  programs.hyprland.enable = true;

  system.stateVersion = "25.05";
}
