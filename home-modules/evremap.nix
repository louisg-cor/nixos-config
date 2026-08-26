{ pkgs, ...}:
let
evremapConfig = {
  device_name = "MX KEYS S";
  remap = [
    {
      input = ["KEY_CAPSLOCK"];
      output = ["KEY_BACKSPACE"];
    }
  ];
};
in
{
  xdg.configFile."evremap/remap.toml".source =
  (pkgs.formats.toml {}).generate "remap.toml" evremapConfig;
}
