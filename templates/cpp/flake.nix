{
  description = "A C++ project for algorithms";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "algoritmen-projekt";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = with pkgs; [ gnumake pkg-config ];
          buildInputs = with pkgs; [ 
            pkg-config
            alsa-lib
            freetype
            libX11
            libXext
            libXcursor
          ];
          
          buildPhase = ''
            make
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp algoritmen-projekt $out/bin/
          '';
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          packages = with pkgs; [
            # Tools für Entwicklung und Editor-Support
            gdb
            clang-tools # für clangd, clang-format, etc.
            cmake
          ];
        };
      }
    );
}