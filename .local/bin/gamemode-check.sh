#!/bin/sh

set -eu

# get clock speed first so retrieval of information doesn't affect it
clock_speed=$(grep 'cpu MHz' /proc/cpuinfo)

gamemoded -s
scxctl get

printf 'hidecursor loaded? '
busctl --user call org.kde.KWin /Effects org.kde.kwin.Effects isEffectLoaded s hidecursor | awk '{ print $2 }'

printf 'governor: '
cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor | sort -u

echo '#### cpu clock ####'
echo "$clock_speed" | sort | uniq -c
