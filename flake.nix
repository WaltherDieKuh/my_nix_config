# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #hyprland.url = "github:hyprwm/Hyprland";
    #hyprland.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:derhalbgrieche/nixvim";
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
    minesddm = {
      url = "github:Davi-S/sddm-theme-minesddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minecraft-plymouth-theme = {
      url = "github:nikp123/minecraft-plymouth-theme";
      flake = false; # Das Repo ist keine Flake
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, minesddm, ... } @ inputs: let
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
      homePC = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Hier geben wir isDesktop und isLaptop als Custom-Variablen mit:
        specialArgs = {
          inherit inputs outputs;
          isDesktop = true;
          isLaptop = false;
        };
        modules = [
          ./hosts/PC/hardware-configuration.nix
          ./hosts/PC/homePC.nix
          inputs.minesddm.nixosModules.default
          inputs.minegrub-theme.nixosModules.default
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
        ];
      };

      laptopUni = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs;
          isDesktop = false;
          isLaptop = true;
        };
        modules = [
          ./hosts/laptopUni/hardware-configuration.nix
          ./hosts/laptopUni/laptopUni.nix
          inputs.minesddm.nixosModules.default
          inputs.minegrub-theme.nixosModules.default
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
