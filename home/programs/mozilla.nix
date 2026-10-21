{ pkgs, config, ...}: 

let
  extensions = [
    "uBlock0@raymondhill.net"     # uBlock
    "jid1-MnnxcxisBPnSXQ@jetpack" # PrivacyBadger
    "seventv-next@7tv.app"        # 7tv
  ];
in

{
  # Mozilla Thunderbird
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings  = {
        "mail.threadpane.listview" = 0;
        "mail.threadpane.cardsview.rowcount" = 2;
        # Tags
        "mailnews.tags.$label1.color" = "#FF0000";
        "mailnews.tags.$label1.tag"   = "Important";
        "mailnews.tags.$label2.color" = "#FF9900";
        "mailnews.tags.$label2.tag"   = "Travel";
        "mailnews.tags.$label3.color" = "#009900";
        "mailnews.tags.$label3.tag"   = "Purchases or Delivery";
        "mailnews.tags.$label4.color" = "#3333FF";
        "mailnews.tags.$label4.tag"   = "Personal or Work";
      };
    };
  };

  # Mozilla Firefox
  programs.firefox = {
    enable = true;
    
    languagePacks = [ "en-GB" "en-US" "de" ];
    configPath    = "${config.xdg.configHome}/mozilla/firefox";
    
    policies = {
      ### DEBLOAT ###
      AIControls = {
        Default.Value = "blocked";
        Translations.Value = "available";
      };
      DisableFirefoxAccounts = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      FirefoxSuggest.WebSuggestions = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        MoreFromMozilla = false;
        SkipOnboarding = true;
        UrlbarInterventions = false;
      };
      
      ### SECURITY ###
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      HttpsOnlyMode = "force_enabled";
      HttpAllowList = [ "http://localhost" "http://127.0.0.1" ];
      OfferToSaveLogins = false;
      PostQuantumKeyAgreementEnabled = true;
      
      ### PRIVACY ###
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        EmailTracking = true;
        Fingerprinting = true;
        SuspectedFingerprinting = true;
        Category = "strict";
      };      
      NetworkPrediction = false;
      Permissions = {
        Notifications = {
          BlockNewRequests = true;
          Locked = true;
        };
        Location = {
          BlockNewRequests = true;
          Locked = true;
        };
      };
      SanitizeOnShutdown = {
        Cache = true;
        FormData = true;
        SiteSettings = true;
      };

      ### EXTENSIONS ###
      ExtensionSettings = builtins.listToAttrs (map (id: {
        name = id;
        value = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
          installation_mode = "force_installed";
        };
      }) extensions);
    };

    profiles.default = {
      isDefault = true;
      name = "default";

      # Search Engines
      search = {
        force = true;
        default = "ddg";
        privateDefault = "ddg";
        order = [ "ddg" "np" "wikipedia" "sx"];

        engines = {
          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "SearXNG" = {
            urls = [{ template = "https://priv.au/search?q={searchTerms}"; }];
            icon = "https://searx.space/favicon.svg";
            definedAliases = [ "@sx" ];
          };

          "google".metaData.hidden     = true;
          "bing".metaData.hidden       = true;
          "ecosia".metaData.hidden     = true;
          "qwant".metaData.hidden      = true;
          "perplexity".metaData.hidden = true;
        };
      };

      # Applied to about:config
      settings = {
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.hideLogo" = true;
        "browser.newtabpage.activity-stream.newtabWallpapers.user.enabled" = true;
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper" = "dark-mountain";
        "browser.newtabpage.activity-stream.showSearch" = false;
        "browser.newtabpage.activity-stream.showWeather" = false;
        "browser.tabs.inTitlebar" = 0;
       	"browser.toolbars.bookmarks.visibility" = "never";
      };
    };
  };

}
