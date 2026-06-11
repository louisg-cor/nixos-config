{ config, pkgs, inputs, ... }:
let
  nixGLIntel = inputs.nixgl.packages.${pkgs.system}.nixGLIntel;
  sway-wrapped = pkgs.writeShellScriptBin "sway" ''
    export PATH=/home/lgalloux/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH
    export NIX_PATH=/nix/var/nix/profiles/per-user/lgalloux/channels
    exec ${nixGLIntel}/bin/nixGLIntel ${pkgs.sway}/bin/sway "$@"
  '';
in
{
  home.file.".wallpaper/tokyonight.png" = {
    source = ../../assets/tokyonight.png;
    target = ".wallpaper/tokyonight.png";
  };

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    checkConfig = false;
    package = sway-wrapped;
    config = {

      startup = [
        { command = "noctalia-shell"; }
        { command = "swaybg -i ${config.home.homeDirectory}/.wallpaper/tokyonight.png -m fill"; }
      ];

      input = {
        "*" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl";
        };
      };

      gaps = {
        inner = 0;
        outer = 0;
      };

      bars = [];  # on désactive la bar par défaut

      window.border = 3;
      window.titlebar = false;

      colors.focused = {
        border = "#7aa2f7";
        background = "#7aa2f7";
        text = "#ffffff";
        indicator = "#bb9af7";
        childBorder = "#7aa2f7";
      };

      colors.unfocused = {
        border = "#595959";
        background = "#595959";
        text = "#ffffff";
        indicator = "#595959";
        childBorder = "#595959";
      };

      modifier = "Mod4";

      keybindings = let mod = "Mod4"; in {
        "${mod}+Return" = "exec alacritty";
        "${mod}+q" = "kill";
        "${mod}+f" = "fullscreen";
        "${mod}+v" = "splith";

        "${mod}+space" = "exec noctalia-shell ipc call launcher toggle";
        "${mod}+Escape" = "exec noctalia-shell ipc call lockScreen lock";
        "${mod}+t" = "exec noctalia-shell ipc call bar toggle";
        "${mod}+Shift+Escape" = "exec noctalia-shell ipc call sessionMenu toggle";

        "${mod}+h" = "focus left";
        "${mod}+l" = "focus right";
        "${mod}+k" = "focus up";
        "${mod}+j" = "focus down";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+j" = "move down";

        "${mod}+r" = "mode resize";

        "XF86MonBrightnessUp" = "exec noctalia-shell ipc call brightness increase";
        "XF86MonBrightnessDown" = "exec noctalia-shell ipc call brightness decrease";
        "XF86AudioRaiseVolume" = "exec noctalia-shell ipc call volume increase";
        "XF86AudioLowerVolume" = "exec noctalia-shell ipc call volume decrease";
        "XF86AudioMute" = "exec noctalia-shell ipc call volume muteOutput";
        "XF86AudioPlay" = "exec noctalia-shell ipc call media playPause";
        "XF86AudioNext" = "exec noctalia-shell ipc call media next";
        "XF86AudioPrev" = "exec noctalia-shell ipc call media previous";
      } // builtins.listToAttrs (builtins.concatLists (builtins.genList (x:
      let
        ws = builtins.toString (x + 1);
        key = if x + 1 == 10 then "0" else ws;
      in [
          { name = "${mod}+${key}"; value = "workspace number ${ws}"; }
          { name = "${mod}+Shift+${key}"; value = "move container to workspace number ${ws}"; }
         ]) 10));

      modes.resize = let mod = "Mod4"; in {
        "l" = "resize grow width 20px";
        "h" = "resize shrink width 20px";
        "k" = "resize shrink height 20px";
        "j" = "resize grow height 20px";
        "Escape" = "mode default";
        "Return" = "mode default";
        "${mod}+r" = "mode default";
      };
    };

    extraConfig = ''
      exec systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
      exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    '';
  };

  home.packages = [ pkgs.swaybg pkgs.swaylock ];
}
