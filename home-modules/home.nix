{  pkgs, config, pkgs-unstable, inputs, osConfig, lib, ...}:
let
  nixGLIntel = inputs.nixgl.packages.${pkgs.system}.nixGLIntel;
  alacritty = pkgs.writeShellScriptBin "alacritty" ''
    exec ${nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
  '';
in
{
  imports =
  [
    ./helix.nix
    ./zen.nix
    ./music.nix
    ./syncthing.nix
    ./zk.nix
    # ./gui/sway.nix
    # ./gui/noctalia.nix
  ]
  ++ (lib.optionals (osConfig.networking.hostName == "nixos-hypr") 
  [
    ./gui/hyprland.nix
    ./gui/noctalia.nix
  ])
  ++ (lib.optionals (osConfig.networking.hostName != "nixos-hypr")
  [
     inputs.stylix.homeModules.stylix
     ../stylix.nix
  ]);

    
  home.packages =
  [
    pkgs.nixd pkgs-unstable.bluetui pkgs.delta
    pkgs.man-pages pkgs.man-pages-posix pkgs.htop
    pkgs.nvtopPackages.amd pkgs.typst
    pkgs.tinymist pkgs.d2 pkgs.vivify
    pkgs.ripgrep pkgs.fzf pkgs.visidata pkgs.pandoc
    pkgs.prettier pkgs.killall pkgs.slurp pkgs.grim
    pkgs.xsel pkgs.evremap
  ];

  stylix.targets = {
    helix.enable = false;
    hyprland.enable = false;
    sway.enable = false;
    kde.enable = false; # should not be enabled on ubuntu 22.04.05
    zen-browser.enable = false;
  };
  
  services.ssh-agent.enable = false;

  xdg.portal =
  {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals =
    [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config =
    {
      common.default = [ "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };
  
  programs.git =
  {
    enable = true;
    settings =
    {
      user.name = "Louis Galloux";
      user.email = "louis.galloux@corintis.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgSigh = true;
    };
  };

  programs.delta =
  {
    enable = true;
    enableGitIntegration = true;
    options =
    {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  programs.ssh =
  {
    enable = true;
    enableDefaultConfig = false;
  };

  programs.zoxide =
  {
    enable = true;
    enableZshIntegration = true;
  };

  programs.alacritty =
  {
    enable = true;
    package = alacritty;
  };

  programs.direnv =
  {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config =
    {
      "warn_timeout" = 0;
    };
  };

  programs.zsh =
  {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases =
    {
      zathura = "zathura --fork";
    };
    
    oh-my-zsh =
    {
      enable = true;
      theme = "robbyrussell";
      plugins =
      [
        "git"
        "docker"
        "kubectl"
      ];
    };
    
    plugins =
    [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = inputs.zsh-nix-shell;
      }
    ];
  };

  programs.zathura =
  {
    enable = true;
    options =
    {
      adjust-open = "best-fit";
      selection-clipboard = "clipboard";
      recolor = true;
      recolor-keephue = true;
      recolor-reverse-video = true;
    };
  };

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  home =
  {
    username = "lgalloux";
    homeDirectory = "/home/lgalloux";
    stateVersion = "25.11";
    sessionPath =
    [
      "$HOME/.local/bin" 
    ];
  };
}
