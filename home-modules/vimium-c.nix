{ ... }:
{
  xdg.configFile."vimium-c/keymappings.json".text = builtins.toJSON
  {
    name = "Vimium C";
    "@time" = "12/3/2025, 4:56:41 PM";
    time = 1764777401614;
    environment =
    {
      extension = "2.12.3";
      platform = "linux";
      firefox = 146;
    };
    exclusionRules = [];
    keyLayout = 2;
    keyMappings = builtins.concatStringsSep "\n"
    [
      "#!no-check"
      "map ge scrollToBottom"
      "map gg scrollToTop"
      "map gh scrollLeft count=9999"
      "map gl scrollRight count=9999"
      "map gn nextTab"
      "map gp previousTab"
      "map v LinkHints.activateModeToSelect"
    ];
    vimSync = true;
  };
}

