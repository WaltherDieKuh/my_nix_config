#Das ist meine hosts/laptopUni.nix 

{ config, pkgs, lib, ... }: {
  imports = [
    ../common/default.nix
    ../modules/neovim.nix
  ];

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    minegrub-theme = {
      enable = true;
      splash = "Hier k\u00f6nnte ein Nazi h\u00e4ngen <3";
      background = "background_options/1.8  - [Classic Minecraft].png";
      boot-options-count = 4;
    };
  };

  networking.hostName = "laptopUni";
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
