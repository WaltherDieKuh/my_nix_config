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
}

