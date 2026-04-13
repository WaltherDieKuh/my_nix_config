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
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "algoritmen-projekt";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [ pkgs.gnumake ];
          
          buildPhase = ''
            make
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp algoritmen-projekt $out/bin/
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            gnumake
            gcc
            gdb
          ];
        };
      }
    );
}