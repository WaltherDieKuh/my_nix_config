#Das ist meine hosts/laptopUni.nix 

{ config, pkgs, ...}: {
  imports = [];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # File systems configuration. You need to edit these to match your partitions.
  # Use `lsblk` or a similar tool to find your device names.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/05c0a8ea0-bf58-4109-b810-c920db6d916b";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5FCD-DF79"; # or "/dev/sda1"
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };
  
  swapDevices = 
  [{device = "/dev/disk/by-uuid/89f0c0dc-d742ö-4546-853f-c01c3789dd99";}];
  
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
