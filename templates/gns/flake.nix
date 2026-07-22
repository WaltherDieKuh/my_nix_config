{
	description = "GNS3 template";

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
				packages.default = pkgs.gns3-gui;

				apps.default = flake-utils.lib.mkApp {
					drv = packages.default;
					exePath = "/bin/gns3-gui";
				};

				devShells.default = pkgs.mkShell {
					packages = with pkgs; [
						gns3-gui
						gns3-server
						qemu
						ubridge
						vpcs
						dynamips
						wireshark
					];

					shellHook = ''
						echo "GNS3 development shell loaded."
						echo "Start the GUI with: gns3-gui"
					'';
				};
			}
		);
}
