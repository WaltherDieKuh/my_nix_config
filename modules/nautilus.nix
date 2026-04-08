{
  config,
  pkgs,
  ...
}: {
  dconf.settings = {
    # Nautilus uses GNOME standard settings
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      show-hidden-files = true;
    };
  };

  # Maintain our GTK dark mode enforcement for older GTK3 apps too
  gtk = {
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  home.packages = with pkgs; [
    nautilus # Der GTK4 Dateimanager
    sushi # Leertaste druecken fur Vorschau!
    loupe # Moderner GNOME GTK4 Bildbetrachter
    file-roller # GNOME Archivmanager
    evince # PDF Betrachter passend zum System
  ];
}
