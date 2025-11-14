{
  pkgs,
  inputs,
  outputs,
  config,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [
    ./greetd.nix
  ];
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services = {
    blueman.enable = true;
    gvfs.enable = true;
    flatpak.enable = true;
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = " set -g fish_greeting ";
  };

  networking = {
    firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  networking.hosts = {
    "127.0.0.1" = ["localhost"];
  };
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    extest.enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
  };
  environment.systemPackages = [pkgs.neovim];
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
  };
  boot = {
    consoleLogLevel = 0;
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    kernelParams = [
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "plymouth.use-simpledrm"
    ];
    plymouth = {
      enable = true;
    };
  };
}

