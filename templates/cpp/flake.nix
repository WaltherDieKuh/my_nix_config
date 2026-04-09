# SPDX-License-Identifier: Unlicense
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      perSystem = {
        system,
        pkgs,
        ...
      }: {
        # Provide tools for compiling C/C++
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # Compilers
            gcc
            clang

            # Build Systems
            gnumake
            cmake
            ninja

            # Tools & LSPs
            clang-tools
            gdb
            valgrind
          ];
        };
      };
    };
}
