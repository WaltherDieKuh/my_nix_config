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

  networking = {
    hostName = "djj-AIO";
    # WLAN-Energiesparmodus aus (immer volle Verbindung)
    networkmanager.wifi.powersave = false;
  };
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

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
    # Kein automatisches Abschalten des Bildschirms / Idle-Aktionen
    logind.settings.Login = {
      IdleAction = "ignore";
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
    };
  };

  # Kiosk: Das Ding soll nie in den Standby/Suspend fallen.
  systemd.targets.sleep.enable = lib.mkForce false;
  systemd.targets.suspend.enable = lib.mkForce false;
  systemd.targets.hibernate.enable = lib.mkForce false;
  systemd.targets.hybrid-sleep.enable = lib.mkForce false;

  # Immer volle Leistung – der Kiosk hängt am Strom.
  systemd.services.cpu-governor-performance = {
    description = "Force CPU scaling governor to performance";
    wantedBy = ["multi-user.target"];
    after = ["systemd-udevd.service"];
    serviceConfig.Type = "oneshot";
    script = ''
      for g in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo performance > "$g" 2>/dev/null || true
      done
    '';
  };

  # Autologin direkt auf tty1 (NixOS startet nur tty1 automatisch;
  # ein VT-Wechsel auf tty2 gibt eine Shell zum Warten)
  services.getty.autologinUser = "djj";

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
    git
    vim
  ];

  fonts.packages = with pkgs; [
    noto-fonts
  ];

  system.stateVersion = "25.05";
}
