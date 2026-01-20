#Das ist meine hosts/laptopUni.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../common/default.nix
    ../../modules/neovim.nix
  ];

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    minegrub-theme = {
      enable = true;
      splash = "C++ - alles kann, nichts muss";
      background = "background_options/1.8  - [Classic Minecraft].png";
      boot-options-count = 4;
    };
  };
  boot.plymouth = {
    enable = true;
    theme = "minecraft";
    themePackages = [pkgs.minecraft-plymouth-theme];
  };

  boot.kernelParams = [
    "quiet"
    "splash"
  ];

  boot.initrd.availableKernelModules = lib.mkBefore ["i915"];

  networking.hostName = "WillisPC";
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

  users.users.willi = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
      "docker"
    ];
    shell = pkgs.fish;
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
    networkmanager
    spotify
    localsend
    zip
    unzip
    sleuthkit
    wineWowPackages.waylandFull
    htop
    btop
    wireplumber
    libgtop
    bluez
    bluez-tools
    dart-sass
    upower
    gvfs
    gtksourceview3
    libsoup_3
    bottles
    prismlauncher
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
  ];

  home-manager.users.willi.wayland.windowManager.hyprland.extraConfig = ''

    monitor=DP-2, 2560x1440@240, 0x0, 1

    monitor=DP-3, 1920x1080@100, -1920x180, 1

    monitor=HDMI-A-1, 1920x1080@100, 2560x180, 1

  '';

  services.xserver.enable = false;

  programs.hyprland.enable = true;

  system.stateVersion = "25.05";
}
