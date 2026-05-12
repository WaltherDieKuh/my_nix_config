#default imports
{
  imports = [
    ./kitty.nix
    ./waybar/waybar.nix
    # niri is a per-user (home-manager) module; include from the user's config instead
    ./wallpaper/wallpaper.nix
    ./email.nix
    ./git.nix
    ./spotifyd.nix
  ];
}
