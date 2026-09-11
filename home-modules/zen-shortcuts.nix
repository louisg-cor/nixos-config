{ ... }:
# Raccourcis clavier Zen, migres depuis zen-shortcuts.json.
#
# Le module ne fusionne que les champs de binding (key / keycode / modifiers /
# disabled) dans le fichier que Zen genere lui-meme ; group, l10nId et action
# sont conserves depuis ce fichier. Seuls les raccourcis reellement modifies
# par rapport aux defauts de Zen sont donc listes ici.
let
  # Les 5 modificateurs doivent etre donnes explicitement : un champ omis prend
  # la valeur null de l'option et ressort tel quel dans le JSON, alors que Zen
  # attend des booleens.
  mods =
  { control ? false, alt ? false, shift ? false, meta ? false, accel ? false }:
  { inherit control alt shift meta accel; };

  # Raccourci libere : sans key ni modifiers, le module ecrit key="",
  # keycode=null et tous les modificateurs a false.
  cleared = id: { inherit id; };

  bind = id: key: modifiers: { inherit id key modifiers; };
in
{
  programs.zen-browser.profiles.lgalloux =
  {
    # Garde-fou : l'activation echoue si Zen change de schema de raccourcis,
    # au lieu de fusionner en silence sur des ids qui n'existent plus.
    # Valeur lue dans about:config (zen.keyboard.shortcuts.version) sur 1.23t.
    keyboardShortcutsVersion = 20;

    keyboardShortcuts =
    [
      # Alt+1..9 libere des onglets pour servir aux workspaces.
      (cleared "key_selectTab1")
      (cleared "key_selectTab2")
      (cleared "key_selectTab3")
      (cleared "key_selectTab4")
      (cleared "key_selectTab5")
      (cleared "key_selectTab6")
      (cleared "key_selectTab7")
      (cleared "key_selectTab8")
      (cleared "key_selectLastTab")

      # Fermetures et nouvelle fenetre desamorcees.
      (cleared "key_quitApplication")   # etait accel+q
      (cleared "key_closeWindow")       # etait accel+maj+w
      (cleared "key_newNavigator")      # etait accel+n

      # Rouvrir la derniere fenetre fermee (desactive par defaut sur 1.23t).
      (bind "key_undoCloseWindow" "n" (mods { accel = true; shift = true; }))

      # Navigation historique facon vim (defaut : alt+gauche / alt+droite).
      (bind "goBackKb"    "H" (mods { shift = true; }))
      (bind "goForwardKb" "L" (mods { shift = true; }))

      # Workspaces : alt+h/l pour naviguer, alt+1..4 pour aller direct.
      (bind "zen-workspace-backward" "H" (mods { alt = true; }))
      (bind "zen-workspace-forward"  "L" (mods { alt = true; }))
      (bind "zen-workspace-switch-1" "1" (mods { alt = true; }))
      (bind "zen-workspace-switch-2" "2" (mods { alt = true; }))
      (bind "zen-workspace-switch-3" "3" (mods { alt = true; }))
      (bind "zen-workspace-switch-4" "4" (mods { alt = true; }))
    ];
  };
}
