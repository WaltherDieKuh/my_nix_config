#Das ist meine hosts/laptopUni.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common/default.nix
  ];

  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };

    kernelParams = [
      "quiet"
      "splash"
    ];
  };

  networking.hostName = "djj-AIO";
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
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  services = {
    pipewire = {
      enable = true;
      jack.enable = true;
    };
    upower = {
      enable = true;
    };
  };
  users.mutableUsers = false;

  users.users.djj = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.fish;
    password = "MAlighting";
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    git-lfs
    networkmanager
    zip
    unzip
    btop
    bluez
    upower
    nemo
    kitty
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  services.xserver.enable = false;

  programs.hyprland.enable = true;

  system.stateVersion = "25.05";
}
