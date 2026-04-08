{inputs, ...}: {
  neovim = _: prev: {
    neovim = inputs.nixvim.packages.${prev.stdenv.hostPlatform.system}.default;
  };
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
  custom = final: prev: {
    magicq = prev.callPackage ../pkgs/magicq.nix {};
    libsForQt5 =
      prev.libsForQt5
      // {
        layer-shell-qt = final.kdePackages.layer-shell-qt;
      };
    layer-shell-qt = final.kdePackages.layer-shell-qt;
    minecraft-plymouth-theme = prev.stdenv.mkDerivation {
      pname = "minecraft-plymouth-theme";
      version = "git";
      src = inputs.minecraft-plymouth-theme;

      installPhase = ''
        runHook preInstall
        local theme_dir="$out/share/plymouth/themes/minecraft"
        mkdir -p "$theme_dir"
        cp -r ./plymouth/* "$theme_dir/"
        mv "$theme_dir/mc.plymouth" "$theme_dir/minecraft.plymouth"
        mv "$theme_dir/mc.script" "$theme_dir/minecraft.script"
        sed -i 's|/mc.script|/minecraft.script|g' "$theme_dir/minecraft.plymouth"
        sed -i 's|/themes/minecraft|/themes/minecraft|g' "$theme_dir/minecraft.plymouth"
        runHook postInstall
      '';

      meta = with prev.lib; {
        description = "A Plymouth theme inspired by Minecraft";
        homepage = "https://github.com/nikp123/minecraft-plymouth-theme";
        license = licenses.unlicense;
        platforms = platforms.linux;
      };
    };
  };
}
