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
    homeserver = "ssh server@192.168.0.150";
  };

  programs.fish.functions = {
    template = {
      description = "Initialisiert ein Nix-Template mit direnv";
      body = ''
        if test -z "$argv[1]"
          echo "Bitte ein Template angeben! (z.B. rust, cpp, java, python)"
          return 1
        end

        nix flake init -t path:/home/willi/my_nix_config#$argv[1]

        # direnv einrichten
        echo "use flake" > .envrc
        direnv allow

        # git initialisieren für das Flake
        if not test -d .git
          git init
        end
        git add flake.nix .envrc

        echo "✅ Template '$argv[1]' erfolgreich geladen und direnv aktiviert!"
      '';
    };
  };
}
