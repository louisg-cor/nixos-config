{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;

    # → ~/.config/opencode/opencode.json
    settings = {
      autoupdate = false;   # binaire géré par nixpkgs
      # model = "anthropic/claude-sonnet-4-5";
    };

    # → ~/.config/opencode/tui.json  (thème + keybinds + plugins TUI)
    # le thème est fourni par stylix (stylix.targets.opencode)
  };
}
