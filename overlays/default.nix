{inputs, ...}: {
  neovim = _: prev: {
    neovim = inputs.nixvim.packages.${prev.system}.default;
  };
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
