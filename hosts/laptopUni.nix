#Das ist meine hosts/laptopUni.nix 

{ config, pkgs, ...}: {
  imports = [];

  nixpkgs.config.allowUnfree = true;

  services.gvfs.enable = true;

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

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  users.users.willi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    git-lfs
    neovim
    papirus-icon-theme
    hicolor-icon-theme
    font-awesome
    emote
    nemo
    comma
    xournalpp
    networkmanagerapplet
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
  ];

  services.xserver.enable = false;
  services.displayManager.enable = false;

  programs.hyprland.enable = true;

  system.stateVersion = "25.05";
}
