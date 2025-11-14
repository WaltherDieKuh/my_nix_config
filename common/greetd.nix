{pkgs, ...}: {
  services.displayManager.sddm = {
    enable = true;
    theme = "minesddm";
    wayland.enable = true;
  };
}
