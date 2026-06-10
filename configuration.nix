{ pkgs, inputs, config, ... }:
{
  imports =
  [
    /home/lgalloux/nixos/hardware-configuration.nix
    ./sddm-theme.nix
    ./stylix.nix
    ./llama.nix
    ./udev-stm32.nix
    inputs.stylix.nixosModules.stylix
  ];

  boot.loader =
  {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 8;
  };
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6; # to avoid bluetooth issues on my mb
  boot.initrd.kernelModules = [ "amdgpu" ];

  programs =
  {
    hyprland.enable = true;
    virt-manager = true;
    xwayland.enable = true;
    hyprland.xwayland.enable = true;
    steam.enable = true;
    gamescope.enable = true;
    zsh.enable = true;
  };

  users.groups.lgalloux.members =
  [
    "lgalloux"
  ];

  users.users.lgalloux =
  {
    group = "lgalloux";
    extraGroups = 
    [ 
      "wheel" "networkmanager"
      "video" "input" "seat"
      "libvirtd" "kvm" "podman"
      "users"
    ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  virtualisation =
  {
    podman =
    {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd.enable = true;
    oci-containers.containers.vane =
    {
      image = "itzcrazykns1337/vane:slim-latest";
      ports = [ "3000:3000" ];
      extraOptions = [ "--add-host=host.docker.internal:host-gateway" ];
      volumes = [ "data:/home/vane/data" ];
    };
  };
  nix.settings.experimental-features=["nix-command" "flakes"];
  security.sudo.extraConfig = ''Defaults !sudoedit_checkdir'';
  security.rtkit.enable = true;

  services =
  {
    xserver.xkb.layout = "us";
    xserver.xkb.variant = "altgr-intl";
    xserver.videoDrivers = [ "amdgpu" ];
    resolved.enable = true;
    pulseaudio.enable = false;
    syncthing.openDefaultPorts = true;
    flatpak.enable = true;
    pipewire =
    {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
    };
    udev.extraRules =
    ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="320f", ATTRS{idProduct}=="5055", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
    snapper.configs =
    {
      home =
      {
        SUBVOLUME = "/home";
        ALLOW_USERS = [ "lgalloux" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "4";   # Garde les 4 dernières heures
        TIMELINE_LIMIT_DAILY = "3";    # Garde les 3 derniers jours
        TIMELINE_LIMIT_WEEKLY = "2";   # Garde les 2 dernières semaines
        TIMELINE_LIMIT_MONTHLY = "1";  # Garde le dernier mois
        TIMELINE_LIMIT_YEARLY = "0";
        TIMELINE_MIN_AGE = "1800";     # (Optionnel) Ne supprime pas les snapshots de moins de 30 min
        NUMBER_CLEANUP = true;
        NUMBER_LIMIT = "5";            # Limite stricte de snapshots normaux
        NUMBER_LIMIT_IMPORTANT = "2";
        EMPTY_PRE_POST_CLEANUP = true;
      };
    };
    searx =
    {
      enable = true;
      package = pkgs.searxng;
      environmentFile = "/home/lgalloux/.config/secrets/searxng.env";
      settings =
      {
        general.debug = false;
        server.bind_address = "0.0.0.0";
        search =
        {
          formats =
          [
            "html"
            "json"
          ];
        };
        engines =
        [
          {
            name = "wolframalpha";
            shortcut = "wa";
            engine = "wolframalpha_noapi";
            timeout = 6.0;
            categories = "science";
            disabled = false;
          }
        ];
      };
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  console.keyMap = "us";
  fonts.packages = with pkgs; [ noto-fonts noto-fonts-color-emoji ];

  networking =
  {
    networkmanager.enable = true;
    firewall =
    {
      trustedInterfaces = [ "podman0" ];
    };
    hostName = "nixos-hypr";
  };

  hardware =
  {
    graphics.enable = true;
    graphics.enable32Bit = true;
    bluetooth =
    {
      enable = true;
      settings.General.ControllerMode = "bredr"; #issue with bluetooth connection
    };
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs;
  [
    vim git podman-compose
  ];

  system.stateVersion = "24.11";
}
