#!/usr/bin/env bash

############ Variables ############
enable_battery=false
battery_charging=false

####### Check availability ########
for battery in /sys/class/power_supply/*BAT*; do
  if [[ -f "$battery/uevent" ]]; then
    enable_battery=true
    if [[ $(cat /sys/class/power_supply/*BAT*/status | head -1) == "Charging" ]]; then
      battery_charging=true
    fi
    break
  fi
done

############# Output #############
if [[ $enable_battery == true ]]; then
  battery_percentage=$(cat /sys/class/power_supply/*BAT*/capacity | head -1)
  if [[ $battery_charging == true ]]; then
    echo -n "󰂄 "
  else
    case $battery_percentage in
    [0-1]?)
      echo -n "󰁻 "
      ;;
    [2-3]?)
      echo -n "󰁼 "
      ;;
    [4-5]?)
      echo -n "󰁿 "
      ;;
    [6-7]?)
      echo -n "󰂀 "
      ;;
    [8-9]?)
      echo -n "󰂂 "
      ;;
    100)
      echo -n "󰁹 "
      ;;
    esac
  fi
  echo -n "${battery_percentage}"󰏰
fi

echo ''
