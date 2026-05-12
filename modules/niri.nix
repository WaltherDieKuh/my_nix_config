{
  config,
  pkgs,
  lib,
  isDesktop,
  isLaptop,
  ...
}: {
  # Umgebungsvariablen werden separat definiert (für Wayland / Qt)
  home.sessionVariables = {
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # SwayOSD bleibt identisch
  services.swayosd.enable = true;

  # `niri` is provided as a package only; it does not expose a home-manager
  # option (e.g. `programs.niri`). The previous `programs.niri` block has
  # been removed to avoid defining non-existent home-manager options.
  # If you want to deploy per-user Niri configuration files, generate them
  # under `xdg.configFile` or `home.file` from another module.
}