{
  description = "A basic Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    devShells = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (python3.withPackages (ps: with ps; [
              numpy
              pip
              pillow
            ]))
          ];

          shellHook = ''
            echo "Python development environment loaded!"
            python --version
          '';
        };
      }
    );
  };
}
