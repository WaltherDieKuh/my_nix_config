# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:derhalbgrieche/nixvim";
   };

  outputs = { self, nixpkgs, home-manager, hyprland, stylix, ... }@inputs: {

    templates = import ./templates;

    nixosConfigurations = {
      laptopUni = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/hardware-configuration.nix
          ./hosts/laptopUni.nix

          stylix.nixosModules.stylix

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
          
            home-manager.users.willi = { 
              imports = [
                stylix.homeManagerModules.stylix # stylix als home-manager-Modul hinzufügen
                ./home/willi.nix
                ./modules/default.nix
              ]; 
            };
          }
          
          hyprland.nixosModules.default

          ({
            nixpkgs.overlays = [
              (final: prev: {
                magicq = prev.callPackage ./pkgs/magicq.nix {};
              })
            ];
          })
        ];
      };
    };
  };
}
