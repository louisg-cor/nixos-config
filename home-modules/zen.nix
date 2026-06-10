{ pkgs, config, inputs, lib, ... }:
let
  colors = config.lib.stylix.colors;
  hexToDec = v: 
    let 
      hexToInt = x: 
        if x >= "0" && x <= "9" then lib.strings.toInt x 
        else { a=10; b=11; c=12; d=13; e=14; f=15; }.${lib.strings.toLower x};
      c1 = hexToInt (builtins.substring 0 1 v);
      c2 = hexToInt (builtins.substring 1 1 v);
    in c1 * 16 + c2;

  toRGB = colorStr:
  {
    r = hexToDec (builtins.substring 0 2 colorStr);
    g = hexToDec (builtins.substring 2 2 colorStr);
    b = hexToDec (builtins.substring 4 2 colorStr);
  };
  
  Focus = toRGB colors.base0E;
  Library = toRGB colors.base09;
  Comms = toRGB colors.base0D;
  Media = toRGB colors.base00;
in
{
  imports =
  [
    inputs.zen-browser.homeModules.twilight
    ./vimium-c.nix
  ];

  # home.file.".zen/lgalloux/zen-keyboard-shortcuts.json" =
  # {
  #   source = ./zen-shortcuts.json;
  # };

  xdg.mimeApps =
  {
    enable = true;
    defaultApplications =
    {
      "text/html" = "zen-twilight.desktop";
      "x-scheme-handler/http" = "zen-twilight.desktop";
      "x-scheme-handler/https" = "zen-twilight.desktop";
      "x-scheme-handler/about" = "zen-twilight.desktop";
      "x-scheme-handler/unknown" = "zen-twilight.desktop";
    };
  };

  programs.zen-browser =
  {
    enable = true;
    # --- Policies & Extensions ---
    policies =
     {
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
    };

    # --- Profil Utilisateur ---
    profiles.lgalloux =
    {
      isDefault = true;
      
      # Paramètres pour activer le CSS Custom
      settings =
      {
        # Zen
        "zen.workspaces.continue-where-left-off" = true;
        "zen.workspaces.natural-scroll" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.animate-sidebar" = false;
        "zen.welcome-screen.seen" = true;
        "zen.urlbar.behavior" = "float";
        "zen.view.sidebar-expanded" = false;
        "zen.view.compact-mode" = true;
        "zen.view.compact.enable-at-startup" = true;
        "zen.view.compact.toolbar-flash-popup" = true;
        "zen.tabs.show-newtab-vertical" = false;
        # Broswer
        "browser.ctrlTab.sortByRecentlyUsed" = false;
        # "browser.display.background_color" = colors.withHashtag.base00;
        # "browser.display.foreground_color" = colors.withHashtag.base05;
        # "browser.display.document_color_use" = 2;
        "browser.anchor_color" = colors.withHashtag.base0C;
        "browser.visited_color" = colors.withHashtag.base0D;
        #Others
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "gfx.webrender.all" = true;
        "ui.systemUsesDarkTheme" = true;
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons;
      [
        ublock-origin
        proton-pass
        vimium-c
      ];

      # Moteurs de recherche (avec alias)
      search =
      {
        force = true;
        default = "Brave";
        engines =
        {
          "Searxng" =
          {
            urls = [{ template = "http://127.0.0.1:8888/search?q={searchTerms}";}];
          };
          "Brave" =
          {
            urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
            icon = "https://brave.com/static-assets/images/brave-logo-sans-text.svg"; 
            updateInterval = 24 * 60 * 60 * 1000; 
            definedAliases = [ "@br" ];
          };
          "Nix Packages" =
          {
            urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Nix Options" =
          {
            urls = [{ template = "https://search.nixos.org/options?channel=25.11&query={searchTerms}";}];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          "Startpage" =
          {
            urls = [{ template = "https://www.startpage.com/rvd/search?query={searchTerms}&language=auto"; }];
            icon = "https://www.startpage.com/sp/cdn/favicons/mobile/android-icon-192x192.png";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [ "@sp" ];
          };
        };
      };
      spacesForce = true;
      spaces =
      {
      "Focus" =
      {
        id = "12345678-1234-1234-1234-123456789001";
        icon = "🧠";
        position = 1;
        theme =
        {
          type = "gradient";
          colors =
          [
            {
              red = Focus.r;
              green = Focus.g;
              blue = Focus.b;
              algorithm = "floating";
              type = "explicit-lightness";
            }
          ];
          opacity = 0.8;
          texture = 0.0;
        };
      };

      "Library" =
      {
        id = "12345678-1234-1234-1234-123456789002";
        icon = "🔍";
        position = 2;
        theme =
        {
          type = "gradient";
          colors =
          [
            {
              red = Library.r;
              green = Library.g;
              blue = Library.b;
              algorithm = "floating";
              type = "explicit-lightness";
            }
          ];
          opacity = 1.0;
          texture = 0.0;
        };
      };

      "Comms" =
      {
        id = "12345678-1234-1234-1234-123456789003";
        icon = "💬";
        position = 3;
        theme =
        {
          type = "gradient";
          colors =
          [
            {
              red = Comms.r;
              green = Comms.g;
              blue = Comms.b;
              algorithm = "floating";
              type = "explicit-lightness";
            }
          ];
          opacity = 1.0;
          texture = 0.0;
        };
      };

      "Media" =
      {
        id = "12345678-1234-1234-1234-123456789004";
        icon = "☕";
        position = 4;
        theme = {
          type = "gradient";
          colors =
          [
            {
              red = Media.r;
              green = Media.g;
              blue = Media.b;
              algorithm = "floating";
              type = "explicit-lightness";
            }
          ];
          opacity = 1.0;
          texture = 0.0;
        };
      };
    };
  };
};
}

