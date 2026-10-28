{ pkgs, lib, ... }:

let
  remaps = [
    { input = [ "KEY_CAPSLOCK" ]; output = [ "KEY_BACKSPACE" ]; }
  ];

  devices = {
    dongle = {
      device_name = "Logitech USB Receiver";
      phys = "usb-0000:00:14.0-1/input0";
    };
    laptop = {
      device_name = "AT Translated Set 2 keyboard";
    };
    bluetooth = {
      device_name = "MX Keys"; # à adapter
    };
  };

  toml = pkgs.formats.toml { };

  mkService = name: dev: lib.nameValuePair "evremap-${name}" {
    Unit.Description = "evremap (${name})";
    Service = {
      ExecStart = "${pkgs.evremap}/bin/evremap remap --wait-for-device ${
        toml.generate "evremap-${name}.toml" (dev // { remap = remaps; })
      }";
      Restart = "always";
      RestartSec = 2;
    };
    Install.WantedBy = [ "default.target" ];
  };
in
{
  systemd.user.services = lib.mapAttrs' mkService devices;
}
