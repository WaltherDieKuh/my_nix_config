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

    wilhelmTraeno = {
      address = "ww@traeno.com";
      userName = "ww@traeno.com";
      flavor = "plain";
      realName = "Wilhelm Wölkner";
      imap = {
        host = "mail.your-server.de";
        port = 993;
        tls.enable = true;
      };
      thunderbird = {
        enable = true;
        profiles = ["Privat"];
      };
      smtp = {
        host = "mail.your-server.de";
        port = 587;
        tls.useStartTls = true;
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
