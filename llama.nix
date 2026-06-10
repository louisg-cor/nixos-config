{ inputs, pkgs, pkgs-unstable, lib, ... }:
{
  environment.systemPackages = 
  [
    pkgs-unstable.llama-cpp-rocm
  ];

  services.llama-cpp =
  {
    enable = true;
    model = "/var/lib/llama-models/gemma-4-26B-A4B-it-UD-Q4_K_M.gguf";
    port = 10001;
    package = pkgs-unstable.llama-cpp-rocm;
    host = "0.0.0.0";
    extraFlags = [ "-c" "131072" "-ngl" "all" "--cache-ram" "0" "--ctx-checkpoints" "0" ];
  };
  
  # systemd.services.llama-swap.environment =
  # {
  #   LISTEN_ADDR = "0.0.0.0:10001"; 
  # };
  # services.llama-swap =
  # {
  #   enable = true;
  #   port = 10001;
  #   settings =
  #   let
  #     llama-server = lib.getExe' pkgs-unstable.llama-cpp-rocm "llama-server";
  #   in
  #   {
  #     healthCheckTimeout = 120;
  #     startPort = 10002;
  #     sendLoadingState = true; 
  #     macros =
  #     {
  #       "models_path" = "/var/lib/llama-models";
  #       "base_cmd" = "${llama-server} --port \${PORT}";
  #     };
  #     models =
  #     {
  #       "gemma4-26b" =
  #       {
  #         cmd = "\${base_cmd} -m \${models_path}/gemma-4-26B-A4B-it-UD-Q4_K_M.gguf -c 184320 -ngl all --cache-ram 0 --ctx-checkpoints 0";
  #         aliases = [ "gpt-3.5-turbo" "gpt-4" ];
  #         filters =
  #         {
  #           stripParams = "temperature, top_p";
  #           setParams =
  #           {
  #             temperature = 0.7;
  #             top_p = 0.9;
  #           };
  #         };
  #       };
  #     };
      # groups =
      # {
      #   "chat" =
      #   {
      #     swap = true;
      #     exclusive = true;
      #     members = [ "qwen3.5-27b" "gemma4-26b" ];
      #   };
      # };
  #   };
  # };
} 
