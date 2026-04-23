{pkgs, ...}: {
  programs.thunderbird = {
    enable = true;
    profiles = {
      Privat = {
        isDefault = true;
      };
    };
  };
  accounts.email.accounts = {
    wilhelmwoelknergmail = {
      address = "wilhelm.woelkner@gmail.com";
      flavor = "gmail.com";
      realName = "Wilhelm Wölkner";
      thunderbird = {
        enable = true;
        profiles = ["Privat"];
      };
    };

    sophiewilhelm = {
      address = "sophiewilhelm06@gmail.com";
      flavor = "gmail.com";
      realName = "SophieWilhelm";
      thunderbird = {
        enable = true;
        profiles = ["Privat"];
      };
    };

    wilhelmFH = {
      address = "wilhelm.woelkner@fh-erfurt.de";
      userName = "wi2785wo";
      flavor = "plain";
      realName = "Wilhelm Wölkner";
      primary = true;
      imap = {
        host = "imap.fh-erfurt.de";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.fh-erfurt.de";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      thunderbird = {
        enable = true;
        profiles = ["Privat"];
      };
    };
  };
}
