{pkgs, ...}: {
  services.displayManager.sessionPackages = [ pkgs.niri ];
  services.displayManager.defaultSession = "niri";
  services.displayManager.sddm = {
    enable = true;
    theme = "minesddm";
    wayland.enable = true;
  };
}
