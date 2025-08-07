#my flake right here
{
  inputs = {
  
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    #wayland?
  }

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nicosConfigurations = {
        laptopUni = nixpkgs.lib.nixosSystem{
          inherit system;
          modules = [
            ./hosts/laptopUni.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPkgs = true;
              home-manager.users.willi = import ./home/willi.nix;
            }
            hyprland.nixosModules.default
          ];
        };
      };
    };

}
