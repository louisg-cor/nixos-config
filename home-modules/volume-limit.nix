{ pkgs,... }:
{
  systemd.user.services.bluetooth-volume-limiter =
  {
    Unit =
    {
      Description = "Limit max volume for bluetooth devices";
      After = [ "pipewire-pulse.service" "wireplumber.service" ];
    };

    Service = {
      Restart = "always";
      RestartSec = "5s";
    
      ExecStart = let
        limit = "40";
      in "${pkgs.writeShellScript "bt-vol-limit" ''
        export PATH=${pkgs.coreutils}/bin:${pkgs.pulseaudio}/bin:${pkgs.gnugrep}/bin:${pkgs.gawk}/bin:$PATH
      
        check_limit() {
          local sink_id=$1
        
          local info=$(pactl list sinks | grep -A 15 "Sink #$sink_id")
          local name=$(echo "$info" | grep "Name:" | awk '{print $2}')
          local vol=$(echo "$info" | grep "Volume:" | head -n1 | awk -F/ '{print $2}' | tr -d ' %')

          if [[ "$name" == *"bluez_output"* ]] && [ -n "$vol" ] && [ "$vol" -gt "${limit}" ]; then
            echo "Volume trop haut ($vol%) sur $name. Limitation à ${limit}%."
            pactl set-sink-volume "$sink_id" ${limit}%
          fi
        }

        echo "Démarrage du limiteur de volume Bluetooth (Max: ${limit}%)"

        pactl list short sinks | cut -f1 | while read id; do check_limit "$id"; done

        pactl subscribe | grep --line-buffered "sink" | while read -r line; do
          sink_id=$(echo "$line" | cut -d'#' -f2)
          check_limit "$sink_id"
        done
      ''}";
    };

    Install =
    {
      WantedBy = [ "default.target" ];
    };
  };
}

