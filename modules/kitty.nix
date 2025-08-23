#kitty config
{pkgs, ...}: {
programs.kitty = {
  enable = true;
  package = pkgs.kitty;
  settings = {
    font-size = 12;
    wheel_scroll_min_lines = 1;
    window_padding_width = 4;
    confirm_os_window_close = 0;
    scrollback_lines = 10000;
    enable_audio_bell = false;
    mouse_hide_wait = 0;
    tab_fade = 1;
  };
};
}
