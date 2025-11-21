{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "store";
      user = {
        name = "Wilhelm Wölkner";
        email = "wilhelm.woelkner@outlook.de";
      };
    };
    signing = {
      format = "ssh";
      signByDefault = true;
      key = "~/.ssh/github.pub";
    };
  };
}
