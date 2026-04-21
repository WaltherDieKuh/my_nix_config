{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.willi = {
      isDefault = true;
      search = {
        force = true;
        default = "ddg";
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                ];
              }
            ];

            definedAliases = ["@nix"];
          };
          "bing".metaData.hidden = true;
          "google".metaData.hidden = true;
          "ebay".metaData.hidden = true;
        };
      };
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Bookmarks Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "Gemini";
                url = "https://gemini.google.com";
              }
              {
                name = "Google Drive";
                url = "https://drive.google.com";
              }
              {
                name = "Google Calendar";
                url = "https://calendar.google.com";
              }
              {
                name = "FHE";
                url = "https://fh-erfurt.de";
              }
              {
                name = "FH-Mail";
                url = "https://fhemail.fh-erfurt.de/";
              }
              {
                name = "GitHub";
                url = "https://github.com";
              }
              {
                name = "FH GitLab";
                url = "https://git.ai.fh-erfurt.de";
              }
              {
                name = "Vaultwarden";
                url = "https://vault.mk-2-home-server.duckdns.org";
              }
              {
                name = "Nextcloud";
                url = "https://nextcloud.mk-2-home-server.duckdns.org";
              }
              {
                name = "AdGuard Home";
                url = "http://mk-2-home-server.duckdns.org:3000";
              }
            ];
          }
        ];
      };

      settings = {
        # --- General UX ---
        "browser.startup.page" = 3; # Start where you left off
        "browser.aboutConfig.showWarning" = false;

        # --- Privacy & Tracking Protection ---
        "browser.contentblocking.category" = "strict";
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;

        # --- Disable Telemetry & Data Collection ---
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;

        # --- Disable Pocket, Sponsored Content & Snippets ---
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;

        # --- Secure connection (HTTPS always) ---
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        # --- Search Bar & Suggestions ---
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;

        # --- Disable built-in password manager ---
        "signon.rememberSignons" = false;
      };
    };
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
          installation_mode = "force_installed";
        };
        "{446900e4-71c2-419f-ad28-16f441b8d1b6}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
}
