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
}
