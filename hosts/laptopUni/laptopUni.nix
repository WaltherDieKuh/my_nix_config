#Das ist meine hosts/laptopUni.nix
{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../../common/default.nix
    ../../modules/neovim.nix
  ];

  # Overlay-Einbindung
  nixpkgs.overlays = [ outputs.overlays.custom ];

  # Home-Manager Konfiguration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.willi = {
      imports = [
        inputs.stylix.homeModules.stylix
        ../../home/willi.nix
        ../../modules/default.nix
      ];
    };
  };

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
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    noto-fonts
  ];

  services.xserver.enable = false;

  programs.hyprland.enable = true;

  system.stateVersion = "25.05";
}
