# home-manager/aliases.nix
{
  pkgs,
  config,
  ...
}: {
  # Definiert Aliase für alle Shells, die Home-Manager verwaltet (z.B. bash, zsh)
  home.shellAliases = {
    # Modernere Terminal-Tools (eza mit Icons statt ls, bat statt cat)
    ls = "eza --icons";
    l = "eza -CF --icons";
    la = "eza -A --icons";
    ll = "eza -alF --icons";
    tree = "eza --tree --icons";
    cat = "bat";

    rebuild = "sudo nixos-rebuild switch --flake /home/willi/my_nix_config#laptopUni";
    search = "nix search nixpkgs";
    gc = "sudo nix-collect-garbage -d";
    update = "cd /home/willi/my_nix_config && sudo nix flake update && rebuild && cd -";
  };
}
