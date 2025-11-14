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
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
    minesddm = {
      url = "github:Davi-S/sddm-theme-minesddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    stylix,
    minesddm,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    inherit lib;
    templates = import ./templates;
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      laptopUni = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./hosts/hardware-configuration.nix
          ./hosts/laptopUni.nix
          minesddm.nixosModules.default

          inputs.minegrub-theme.nixosModules.default

          stylix.nixosModules.stylix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";

            home-manager.users.willi = {
              imports = [
                stylix.homeModules.stylix
                ./home/willi.nix
                ./modules/default.nix
              ];
            };
          }

          hyprland.nixosModules.default

          # Das Overlay-Modul wird hier als letztes Element eingefügt
          (
            {
              config,
              pkgs,
              ...
            }: {
              nixpkgs.overlays = [
                (final: prev: {
                  magicq = prev.callPackage ./pkgs/magicq.nix {};
                })
              ];
            }
          )
        ];
      };
    };
  };
}
