{ pkgs-unstable, ... }:
{
  programs.opencode = {
    enable = true;
    # nixpkgs 26.05 est bloque sur opencode 1.15.10 (OpenTUI 0.2.x), trop vieux
    # pour les plugins vim actuels qui exigent >= 1.17.10 / OpenTUI 0.4.x.
    package = pkgs-unstable.opencode;

    settings = {
      autoupdate = false;
    };

    # Les plugins de TUI se declarent dans tui.json, pas opencode.json.
    tui = {
      # Mode vim dans le prompt : motions, operateurs, text objects, registres,
      # visual, dot repeat. Toggle via /vim ou la palette de commandes.
      plugin = [ "@leohenon/opencode-vim-plugin" ];
    };
  };
}
