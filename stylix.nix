{ pkgs, config, ... }:
{
  stylix =
  {
    enable = true;
    base16Scheme = ./home-modules/tokyo-night-custom.yaml;
    image = config.lib.stylix.pixel "base00";
    polarity = "dark";

    # fonts =
    # {
    #   monospace =
    #   {
    #     package = pkgs.nerd-fonts.jetbrains-mono;
    #     name = "JetBrainsMono Nerd Font Mono";
    #   };
    # };
  };
}

