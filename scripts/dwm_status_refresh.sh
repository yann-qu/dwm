#!/bin/bash

# Screenshot: http://s.natalian.org/2013-08-17/dwm_status.png
# Network speed stuff stolen from http://linuxclues.blogspot.sg/2009/11/shell-script-show-network-speed.html

# This function parses /proc/net/dev file searching for a line containing $interface data.
# Within that line, the first and ninth numbers after ':' are respectively the received and transmited bytes.
function get_bytes {
    # Find active network interface
    interface=$(ip route get 8.8.8.8 2>/dev/null | awk '{print $5}')
    line=$(grep $interface /proc/net/dev | cut -d ':' -f 2 | awk '{print "received_bytes="$1, "transmitted_bytes="$9}')
    eval $line
    now=$(date +%s%N)
}

# Function which calculates the speed using actual and old byte number.
# Speed is shown in KByte per second when greater or equal than 1 KByte per second.
# This function should be called each second.

function get_velocity {
    value=$1
    old_value=$2
    now=$3

    timediff=$(($now - $old_time))
    velKB=$(echo "1000000000*($value-$old_value)/1024/$timediff" | bc)
    if test "$velKB" -gt 1024; then
        echo $(echo "scale=2; $velKB/1024" | bc)MB/s
    else
        echo ${velKB}KB/s
    fi
}

# Get initial values
get_bytes
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes
old_time=$now

# Print volume
print_volume() {
    volume="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
    if test "$volume" -gt 0; then
        echo -e "\uE05D${volume}"
    else
        echo -e "Mute"
    fi
}

# Print memory usage
print_mem() {
    memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
    echo -e "$memfree"
}

# Print the temperature
print_temp() {
    test -f /sys/class/thermal/thermal_zone0/temp || return 0
    echo $(head -c 2 /sys/class/thermal/thermal_zone0/temp)°C
}

# Get time until charged
get_time_until_charged() {

    # parses acpitool's battery info for the remaining charge of all batteries and sums them up
    sum_remaining_charge=$(acpitool -B | grep -E 'Remaining capacity' | awk '{print $4}' | grep -Eo "[0-9]+" | paste -sd+ | bc)

    # finds the rate at which the batteries being drained at
    present_rate=$(acpitool -B | grep -E 'Present rate' | awk '{print $4}' | grep -Eo "[0-9]+" | paste -sd+ | bc)

    # divides current charge by the rate at which it's falling, then converts it into seconds for `date`
    seconds=$(bc <<<"scale = 10; ($sum_remaining_charge / $present_rate) * 3600")

    # prettifies the seconds into h:mm:ss format
    pretty_time=$(date -u -d @${seconds} +%T)

    echo $pretty_time
}

# Get battery combined percent
get_battery_combined_percent() {

    # ubuntu错误地向报告有两块电池
    # 这里只提取Barrery 0的信息，这是笔记本电脑的电池

    # get charge of all batteries, combine them
    total_charge=$(expr $(acpi -b | grep Battery\ 0 | awk '{print $4}' | grep -Eo "[0-9]+" | paste -sd+ | bc))

    # get amount of batteries in the device
    battery_number=$(acpi -b | grep Battery\ 0 | wc -l)

    percent=$(expr $total_charge / $battery_number)

    echo $percent
}

# Get battery charging status
get_battery_charging_status() {

    # ubuntu错误地向报告有两块电池
    # 这里只提取Barrery 0的信息，这是笔记本电脑的电池
    if $(acpi -b | grep Battery\ 0 | grep --quiet Discharging); then
        echo ""
    else # acpi can give Unknown or Charging if charging, https://unix.stackexchange.com/questions/203741/lenovo-t440s-battery-status-unknown-but-charging
        echo ""
    fi
}

# Print battery status
print_bat() {
    #hash acpi || return 0
    #onl="$(grep "on-line" <(acpi -V))"
    #charge="$(awk '{ sum += $1 } END { print sum }' /sys/class/power_supply/BAT*/capacity)%"
    #if test -z "$onl"
    #then
    ## suspend when we close the lid
    ##systemctl --user stop inhibit-lid-sleep-on-battery.service
    #echo -e "${charge}"
    #else
    ## On mains! no need to suspend
    ##systemctl --user start inhibit-lid-sleep-on-battery.service
    #echo -e "${charge}"
    #fi
    #echo "$(get_battery_charging_status) $(get_battery_combined_percent)%, $(get_time_until_charged )";
    echo "$(get_battery_charging_status) $(get_battery_combined_percent)%, $(get_time_until_charged)"
}

# Print date
print_date() {
    date '+%Y年%m月%d日 %H:%M'
}

# Execute dwm_alsa.sh
# The variable IDENTIFIER is used in dwm_alsa.sh.
# If unicode, it will display icon. Otherwise, it will display text.
# I prefer text.
# export IDENTIFIER="unicode"
. "dwm_alsa.sh"

get_bytes

# Calculates speeds
vel_recv=$(get_velocity $received_bytes $old_received_bytes $now)
vel_trans=$(get_velocity $transmitted_bytes $old_transmitted_bytes $now)

# Display all the message
xsetroot -name "MEM $(print_mem)M |  $vel_recv  $vel_trans | $(dwm_alsa) | $(print_bat) | $(print_temp) | $(print_date) "

# Update old values to perform new calculations
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes
old_time=$now

exit 0

