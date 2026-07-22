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

  services.gns3-server = {
    enable = true;
    dynamips.enable = true;
    ubridge.enable = true;
    vpcs.enable = true;
  };

  users.users.willi.extraGroups = [
    "docker"
    "cdrom"
  ];

  environment.systemPackages = with pkgs; [
    prismlauncher
  ];

  programs.k3b.enable = true;
}
