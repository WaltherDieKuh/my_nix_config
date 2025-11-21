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
    minecraft-plymouth-theme = {
      url = "github:nikp123/minecraft-plymouth-theme";
      flake = false; # Das Repo ist keine Flake
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
                  libsForQt5 =
                    prev.libsForQt5
                    // {
                      # Leite die alte Anfrage an den neuen Ort weiter
                      layer-shell-qt = final.kdePackages.layer-shell-qt;
                    };

                  # Bonus: Manche alten Pakete suchen vielleicht auch hier.
                  # Dies ist optional, aber sicher ist sicher.
                  layer-shell-qt = final.kdePackages.layer-shell-qt;
                  minecraft-plymouth-theme = prev.stdenv.mkDerivation {
                    pname = "minecraft-plymouth-theme";
                    version = "git";
                    src = inputs.minecraft-plymouth-theme;

                    installPhase = ''
                      runHook preInstall

                      # Zielverzeichnis im Store anlegen
                      local theme_dir="$out/share/plymouth/themes/minecraft"
                      mkdir -p "$theme_dir"

                      # Quell-Verzeichnis kopieren
                      cp -r ./plymouth/* "$theme_dir/"

                      # Dateien umbenennen, um der Plymouth-Konvention zu entsprechen (theme_name/theme_name.plymouth)
                      mv "$theme_dir/mc.plymouth" "$theme_dir/minecraft.plymouth"
                      mv "$theme_dir/mc.script" "$theme_dir/minecraft.script"

                      # Pfade innerhalb der .plymouth-Datei korrigieren, damit sie auf die neuen Dateinamen zeigen
                      sed -i 's|/mc.script|/minecraft.script|g' "$theme_dir/minecraft.plymouth"
                      sed -i 's|/themes/minecraft|/themes/minecraft|g' "$theme_dir/minecraft.plymouth" # Stellt sicher, dass der Pfad stimmt

                      runHook postInstall
                    '';

                    meta = with prev.lib; {
                      description = "A Plymouth theme inspired by Minecraft";
                      homepage = "https://github.com/nikp123/minecraft-plymouth-theme";
                      license = licenses.unlicense;
                      platforms = platforms.linux;
                    };
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
