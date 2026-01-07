# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
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
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      AIO = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs outputs;
        };
        modules = [
          ./hosts/hardware-configuration.nix
          ./hosts/AIO.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";

              users.djj = {
                imports = [
                  ./home/djj.nix
                  ./modules/default.nix
                ];
              };
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
                  libsForQt5 =
                    prev.libsForQt5
                    // {
                      layer-shell-qt = final.kdePackages.layer-shell-qt;
                    };
                })
              ];
            }
          )
        ];
      };
    };
  };
}
