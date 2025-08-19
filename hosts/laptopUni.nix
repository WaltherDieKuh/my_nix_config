#Das ist meine hosts/laptopUni.nix 

{ config, pkgs, ...}: {
  imports = [];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # File systems configuration. You need to edit these to match your partitions.
  # Use `lsblk` or a similar tool to find your device names.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos"; # or "/dev/sda2"
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot"; # or "/dev/sda1"
    fsType = "vfat";
  };
  
  networking.hostName = "laptopUni";
  time.timeZone = "Europe/Berlin";

  users.users.willi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  services.xserver.enable = false;
  services.displayManager.enable = false;

  programs.hyprland.enable = true;

  system.stateVersion = "25.05";
}
