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
  ];

  networking.hostName = "WillisPC";

  virtualisation.docker.enable = true;
  boot.loader.grub.useOSProber = true;
  time.hardwareClockInLocalTime = true;

  users.users.willi.extraGroups = [
    "docker"
    "cdrom"
  ];

  environment.systemPackages = with pkgs; [
    prismlauncher
  ];

  programs.k3b.enable = true;

  home-manager.users.willi = {
    programs.onlyoffice.enable = true;
    wayland.windowManager.hyprland.extraConfig = ''

        monitor=DP-2, 2560x1440@240, 0x0, 1

        monitor=DP-3, 1920x1080@100, -1920x180, 1

        monitor=HDMI-A-1, 1920x1080@100, 2560x180, 1

        device {
        name = wacom-intuos-bt-s-pen
        output = DP-2
    }

  '';
  };
}
