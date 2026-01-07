# home-manager/aliases.nix
{
  pkgs,
  config,
  ...
}: {
  # Definiert Aliase für alle Shells, die Home-Manager verwaltet (z.B. bash, zsh)
  home.shellAliases = {
    ls = "ls --color=auto";
    l = "ls -CF";
    la = "ls -A";
    ll = "ls -alF";

    rebuild = "sudo nixos-rebuild switch --flake .#AIO";
    search = "nix search nixpkgs";
    gc = "sudo nix-collect-garbage";
  };
}
