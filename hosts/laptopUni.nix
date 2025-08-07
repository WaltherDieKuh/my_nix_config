# host configuration for laptopUni

{ config, pkgs, ...}: {
  imports = [];

  nixppkgs.config.allowUnfree = true;
  
  networking.hostName = "laptopUni";
  time.timeZone = "Europe/Berlin";

  users.users.willi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
  };

  enviromnemt.systemPackages = with pkgs; [
    vim
    git
  ];

  services.xserver.enable = false;
  services.displayManager.enable = false;
  console.useXkbConfig = true;

  programs.hyprland.enable = true;

  system.stateVersion = "25.05";
