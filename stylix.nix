{ pkgs, config, ... }:
{
  stylix =
  {
    enable = true;
    base16Scheme = ./home-modules/tokyo-night-custom.yaml;
    image = config.lib.stylix.pixel "base00";
    polarity = "dark";

    # Pilote bar/capsule/panel/dock de noctalia via
    # stylix/modules/noctalia-shell/hm.nix. popups reste a 1.0 (defaut).
    opacity.desktop = 0.38;

    # fonts =
    # {
    #   monospace =
    #   {
    #     package = pkgs.nerd-fonts.jetbrains-mono;
    #     name = "JetBrainsMono Nerd Font Mono";
    #   };
    # };
    fonts =
    {
      sizes.terminal = 15;
    };
  };
}

