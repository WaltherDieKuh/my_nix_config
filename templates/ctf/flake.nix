{
  description = "Slicer Holocron - CTF Arsenal & Dev Environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    sageFast = pkgs.sage.override {
      requireSageTests = false;
      withDoc = true;
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        gef
        radare2
        ropgadget
        checksec
        patchelf
        strace
        ltrace
        binutils
        ghostscript

        one_gadget
        pwninit
        unzip
        bash
        perf

        nmap
        socat
        curl
        wget
        dig

        binwalk
        exiftool
        file
        xxd
        jq
        sageFast
        go
        foundry

        (python3.withPackages (
          ps:
            with ps; [
              pwntools
              requests
              pycryptodome
              z3-solver
              pillow
              pip
            ]
        ))
      ];
    };
  };
}
