{ pkgs, ...}:
{
  environment.systemPackages =
  [
    (pkgs.sddm-astronaut.override
    {
      embeddedTheme = "pixel_sakura";
    })
  ];
  services.displayManager.sddm =
  {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";
    extraPackages = [ pkgs.sddm-astronaut ];
  };
}
