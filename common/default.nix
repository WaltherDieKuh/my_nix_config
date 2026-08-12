{
  pkgs,
  ...
}: {
  programs.fish.enable = true;

  networking = {
    networkmanager.enable = true;
    hosts."127.0.0.1" = ["localhost"];
  };

  nixpkgs.config.allowUnfree = true;
}
