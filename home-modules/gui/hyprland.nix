{ config, lib, ... }:
let
  inherit (lib.generators) mkLuaInline;

  mainMod = "SUPER";

  # Helpers de traduction vers l'API lua de Hyprland (hl.*).
  # Reference : ${hyprland}/share/hypr/stubs/hl.meta.lua
  exec = cmd: mkLuaInline ''hl.dsp.exec_cmd("${cmd}")'';
  dsp = expr: mkLuaInline "hl.dsp.${expr}";

  # hl.bind(keys, dispatcher[, opts])
  bind = keys: dispatcher: { _args = [ keys dispatcher ]; };
  bindRepeat = keys: dispatcher: { _args = [ keys dispatcher { repeating = true; } ]; };

  # hl.env(NAME, VALUE)
  env = name: value: { _args = [ name value ]; };

  # 10 espaces de travail : touches 1..9 puis 0
  workspaceBinds = builtins.concatLists (builtins.genList
    (
      x: let
        n = x + 1;
        key = builtins.toString (n - ((n / 10) * 10));
      in
      [
        (bind "${mainMod} + ${key}" (dsp "focus({ workspace = ${toString n} })"))
        (bind "${mainMod} + SHIFT + ${key}" (dsp "window.move({ workspace = ${toString n} })"))
      ]
    )
    10);
in
{
  home.file.".wallpaper/tokyonight.png" =
  {
    source = ../../assets/tokyonight.png;
    target = ".wallpaper/tokyonight.png";
  };

  services.hyprpaper =
  {
    enable = true;
    settings =
    {
      preload =
      [
        "${config.home.homeDirectory}/.wallpaper/tokyonight.png"
      ];
      wallpaper =
      [
        ",${config.home.homeDirectory}/.wallpaper/tokyonight.png"
      ];
    };
  };

  wayland.windowManager.hyprland =
  {
    enable = true;
    xwayland.enable = true;

    # hyprlang est deprecie depuis Hyprland 0.55 (le wiki ne documente plus que
    # lua, et le code range le parseur .conf sous src/config/legacy/).
    configType = "lua";

    settings =
    {
      # hl.monitor({ output, mode, position, scale })
      monitor =
      [
        { output = ""; mode = "preferred"; position = "auto-up"; scale = 1; }
        { output = "DP-2"; mode = "2560x1600@144"; position = "auto"; scale = 1.33; }
      ];

      env =
      [
        (env "XDG_SESSION_TYPE" "wayland")
        (env "XDG_CURRENT_DESKTOP" "Hyprland")
        (env "XDG_SESSION_DESKTOP" "Hyprland")
        (env "NIXOS_OZONE_WL" "1")
        (env "MOZ_ENABLE_WAYLAND" "1")
      ];

      # Les anciennes sections hyprlang passent toutes par hl.config({ ... }).
      config =
      {
        general =
        {
          gaps_in = 0;
          gaps_out = 0;
          border_size = 3;
          col =
          {
            active_border =
            {
              colors = [ "rgba(7aa2f7ee)" "rgba(bb9af7ee)" ];
              angle = 45;
            };
            inactive_border = "rgba(595959aa)";
          };
          layout = "dwindle";
        };

        decoration =
        {
          rounding = 8;
          blur =
          {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        cursor =
        {
          no_warps = true;
          persistent_warps = true;
          hide_on_key_press = true;
          inactive_timeout = 3;
        };

        input =
        {
          kb_layout = "us";
          kb_variant = "altgr-intl";
          follow_mouse = 1;
          touchpad.natural_scroll = true;
        };

        misc =
        {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        dwindle =
        {
          pseudotile = true;
          preserve_split = true;
        };
      };

      bind =
      [
        (bind "${mainMod} + Return" (exec "alacritty"))
        (bind "${mainMod} + Q" (dsp "window.close()"))
        (bind "${mainMod} + F" (dsp "window.fullscreen()"))
        (bind "${mainMod} + P" (dsp "window.pseudo()"))
        (bind "${mainMod} + V" (dsp ''layout("togglesplit")''))

        (bind "${mainMod} + SPACE" (exec "noctalia-shell ipc call launcher toggle"))
        (bind "${mainMod} + ESCAPE" (exec "noctalia-shell ipc call lockScreen lock"))
        (bind "${mainMod} + T" (exec "noctalia-shell ipc call bar toggle"))
        (bind "${mainMod} + SHIFT + ESCAPE" (exec "noctalia-shell ipc call sessionMenu toggle"))

        (bind "${mainMod} + H" (dsp ''focus({ direction = "l" })''))
        (bind "${mainMod} + L" (dsp ''focus({ direction = "r" })''))
        (bind "${mainMod} + K" (dsp ''focus({ direction = "u" })''))
        (bind "${mainMod} + J" (dsp ''focus({ direction = "d" })''))

        (bind "${mainMod} + SHIFT + H" (dsp ''window.move({ direction = "l" })''))
        (bind "${mainMod} + SHIFT + L" (dsp ''window.move({ direction = "r" })''))
        (bind "${mainMod} + SHIFT + K" (dsp ''window.move({ direction = "u" })''))
        (bind "${mainMod} + SHIFT + J" (dsp ''window.move({ direction = "d" })''))

        (bind "${mainMod} + R" (dsp ''submap("resize")''))

        (bind "XF86MonBrightnessUp" (exec "noctalia-shell ipc call brightness increase"))
        (bind "XF86MonBrightnessDown" (exec "noctalia-shell ipc call brightness decrease"))
        (bind "XF86AudioRaiseVolume" (exec "noctalia-shell ipc call volume increase"))
        (bind "XF86AudioLowerVolume" (exec "noctalia-shell ipc call volume decrease"))
        (bind "XF86AudioMute" (exec "noctalia-shell ipc call volume muteOutput"))
        (bind "XF86AudioPlay" (exec "noctalia-shell ipc call media playPause"))
        (bind "XF86AudioNext" (exec "noctalia-shell ipc call media next"))
        (bind "XF86AudioPrev" (exec "noctalia-shell ipc call media previous"))
      ]
      ++ workspaceBinds;
    };

    # Remplace l'ancien bloc extraConfig `submap = resize ... submap = reset`.
    # binde -> hl.bind(..., { repeating = true }).
    # resizeactive est relatif en hyprlang, d'ou relative = true ici.
    submaps.resize.settings.bind =
    [
      (bindRepeat "l" (dsp "window.resize({ x = 20, y = 0, relative = true })"))
      (bindRepeat "h" (dsp "window.resize({ x = -20, y = 0, relative = true })"))
      (bindRepeat "k" (dsp "window.resize({ x = 0, y = -20, relative = true })"))
      (bindRepeat "j" (dsp "window.resize({ x = 0, y = 20, relative = true })"))

      (bind "escape" (dsp ''submap("reset")''))
      (bind "Return" (dsp ''submap("reset")''))
      (bind "${mainMod} + R" (dsp ''submap("reset")''))
    ];

    # exec-once : en lua, on passe par le hook de demarrage.
    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("noctalia-shell")
      end)
    '';
  };
}
