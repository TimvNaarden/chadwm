#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

# load colors
. ~/.config/chadwm/scripts/bar_themes/catppuccin

cpu() {
  c=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%%"}')
  printf "^c$green^ ^b$black^ "
  printf "^c$green^ ^b$black^ $c"
}

battery() {
  charging=$(cat /sys/class/power_supply/BAT0/status)
  capacity=$(cat /sys/class/power_supply/BAT0/capacity)
  cbicons="󰢟󰢜󰂆󰂇󰂈󰢝󰂉󰢞󰂊󰂋"
  bicons="󰁺󰁻󰁼󰁽󰁾󰁿󰂀󰂁󰂂󰁹"
  if [ "$charging" = "Charging" ]; then
   	b=$(expr substr $cbicons $(($capacity / 10)) 1)
  else
	b=$(expr substr $bicons $(($capacity / 10)) 1)
  fi
  	printf "     ^c$blue^ $b $capacity"
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
  clocks="󱑊󱐿󱑀󱑁󱑂󱑃󱑄󱑅󱑆󱑇󱑈󱑉"
  time=$(date '+%H')
  hour=$(echo "$time%12+1" | bc)
  c=$(expr substr $clocks $hour 1)
	printf "^c$black^ ^b$darkblue^ $c "
	printf "^c$black^^b$blue^ $(date '+%H:%M')  "
}

while true; do
  sleep 1 && xsetroot -name "$(battery) $(cpu) $(mem) $(wlan) $(clock)"
done
