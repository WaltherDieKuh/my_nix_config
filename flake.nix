# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: {
    # Wir brauchen den 'overlays'-Abschnitt hier oben nicht mehr.

    nixosConfigurations = {
      laptopUni = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/hardware-configuration.nix
          ./hosts/laptopUni.nix

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          
            home-manager.users.willi = { 
              imports = [
                ./home/willi.nix
                ./modules/default.nix
              ]; 
            };
          }
          
          hyprland.nixosModules.default

          # --- HIER IST DIE ÄNDERUNG ---
          # Wir fügen das Overlay direkt hier hinzu.
          # Das macht den Code leichter lesbar, weil alles an einem Ort ist.
          ({
            # Dieses Modul fügt unser Overlay zu den Nix Packages hinzu.
            nixpkgs.overlays = [
              (final: prev: {
                # Der Name, unter dem das Paket verfügbar sein wird (pkgs.magicq)
                magicq = prev.callPackage ./pkgs/magicq.nix {};
              })
            ];
          })
        ];
      };
    };
  };
}
