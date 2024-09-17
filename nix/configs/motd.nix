{
  config,
  lib,
  pkgs,
  ...
}: let
  check-services = pkgs.writeShellScriptBin "check-services" ''
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    ENDCOLOR=$(tput sgr0)

    for service in jellyfin transmission bazarr prowlarr radarr sonarr podman-jellyseerr caddy; do
      if [[ $service == podman-* ]]; then
        service_name=$(echo $service | sed 's/podman-//')
      else
        service_name=$service
      fi

      service_status=$(systemctl is-active "$service_name.service" 2>/dev/null)

      if echo "$service_status" | grep -q 'failed'; then
        printf "$RED• $ENDCOLOR%-50s $RED[failed]$ENDCOLOR\n" "$service_name"
      elif echo "$service_status" | grep -q 'active'; then
        printf "$GREEN• $ENDCOLOR%-50s $GREEN[active]$ENDCOLOR\n" "$service_name"
      else
        printf "• %-50s [status unknown]\n" "$service_name"
      fi
    done

  '';
  motd =
    pkgs.writeShellScriptBin "motd"
    ''
      source /etc/os-release
      service_status=$(systemctl list-units | grep podman-)
      RED="\e[31m"
      GREEN="\e[32m"
      BOLD="\e[1m"
      ENDCOLOR="\e[0m"
      LOAD1=`cat /proc/loadavg | awk {'print $1'}`
      LOAD5=`cat /proc/loadavg | awk {'print $2'}`
      LOAD15=`cat /proc/loadavg | awk {'print $3'}`

      MEMORY=`free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100 / $2 }'`

      # time of day
      HOUR=$(date +"%H")
      if [ $HOUR -lt 12  -a $HOUR -ge 0 ]
      then    TIME="morning"
      elif [ $HOUR -lt 17 -a $HOUR -ge 12 ]
      then    TIME="afternoon"
      else
          TIME="evening"
      fi


      uptime=`cat /proc/uptime | cut -f1 -d.`
      upDays=$((uptime/60/60/24))
      upHours=$((uptime/60/60%24))
      upMins=$((uptime/60%60))
      upSecs=$((uptime%60))

      printf "$BOLD Welcome to $(hostname)!$ENDCOLOR\n"
      printf "\n"
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "Release" "$PRETTY_NAME"
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "Kernel" "$(uname -rs)"
      printf "\n"
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "CPU usage" "$LOAD1, $LOAD5, $LOAD15 (1, 5, 15 min)"
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "Memory" "$MEMORY"
      printf "$BOLD  * %-20s$ENDCOLOR %s\n" "System uptime" "$upDays days $upHours hours $upMins minutes $upSecs seconds"

      printf "\n"
      printf "$BOLDService status$ENDCOLOR\n"

      ${check-services}/bin/check-services
    '';
in {
  programs.fish.interactiveShellInit = lib.mkIf config.programs.fish.enable ''
    ${motd}/bin/motd
  '';
}
