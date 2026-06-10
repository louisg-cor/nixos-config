{ inputs, config, pkgs, ... }:
let
  musicDir = "${config.home.homeDirectory}/Music";

  blissify-rs = pkgs.rustPlatform.buildRustPackage
  {
    name = "blissify-unstable";
    src = inputs.blissify-rs-src;
    cargoHash = "sha256-ShStjDSeXCSLU1u2SkAS3HCeRDAOpvNH71Sm/787RM0=";
    nativeBuildInputs = [ pkgs.pkg-config pkgs.llvmPackages.libclang ];
    buildInputs = [ pkgs.ffmpeg pkgs.sqlite pkgs.alsa-lib ];
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

    BINDGEN_EXTRA_CLANG_ARGS = 
      "-isystem ${pkgs.llvmPackages.libclang.lib}/lib/clang/${pkgs.llvmPackages.libclang.version}/include " +
      "-isystem ${pkgs.glibc.dev}/include";

    doCheck = false;
  };
in
{
  imports = [ ./volume-limit.nix ];
  
  home.packages = [
    pkgs.picard
    pkgs.chromaprint
    pkgs.opusTools
    pkgs.cava
    blissify-rs
  ];

  services.mpd =
  {
    enable = true;
    musicDirectory = "${musicDir}";
    playlistDirectory = "${musicDir}/playlist";
    network =
    {
      startWhenNeeded = true;
    };
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
      audio_output {
        type "fifo"
        name "Visualizer"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };

  services.mpd-mpris =
  {
    enable = true;
    mpd = { host = "localhost"; port = 6600; };
  };

  services.mpdscribble =
  {
    enable = false;
    endpoints =
    {
      "last.fm" = {
        username = "thryndir";
        passwordFile = "/home/lgalloux/.config/secrets/lastfm_pass";
      };
    };
  };

  programs.yt-dlp =
  {
    enable = true;
    settings =
    {
      "format" = "bestaudio/best";
      "extract-audio" = true;
      "audio-format" = "opus";
      "audio-quality" = "0";
      "add-metadata" = true;
      "embed-thumbnail" = true;
      "no-write-thumbnail" = true;
      "output" = "${musicDir}/Imports/%(title)s.%(ext)s";
    };
  };

  programs.rmpc.enable = true;
  xdg.configFile."rmpc/config.ron".source = ./rmpc.ron;

  programs.beets =
  {
    enable = true;
    settings =
    {
      directory = "${musicDir}";
      library = "${config.home.homeDirectory}/.config/beets/musiclibrary.db";
      import =
      {
        copy = false;
        move = false;
        write = false;
        incremental = true;
        duplicate_action = "remove";
        autotag = false;
      };
      plugins =
      [
        "mpdupdate"
        "lastgenre"
        "smartplaylist"
      ];
      mpdupdate =
      {
        host = "localhost";
        port = 6600;
      };
      lastgenre =
      {
        auto = true;
        fallback = "";
      };
      smartplaylist =
      {
        playlist_dir = "${musicDir}/playlist";
        relative_to = "${musicDir}";
        auto = true;
        playlists =
        [
          { name = "all.m3u"; query = ""; }
          { name = "recent.m3u"; query = "added:-1w.."; }
          { name = "singles.m3u"; query = "artist: 'Various Artists'"; }
        ];
      };
    };
  };
}

