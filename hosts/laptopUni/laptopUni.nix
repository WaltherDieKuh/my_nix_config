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

  networking.hostName = "laptopUni";

  environment.systemPackages = with pkgs; [
    rnote
    libinput
    libwacom
    python3
    python314Packages.pip
  ];

  services.xserver.wacom.enable = false;

# Aktiviere stattdessen den OpenTabletDriver
  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;


  services.tailscale.enable = true;
}
