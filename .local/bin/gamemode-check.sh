#!/bin/dash

set -eu

# get clock speed first so retrieval of information doesn't affect it
clock_speed=$(grep MHz /proc/cpuinfo)

gamemoded -s
scxctl get
echo "hidecursor loaded? $(qdbus org.kde.KWin /Effects isEffectLoaded hidecursor)"

echo '#### governor ####'
cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor

echo '#### cpu clock ####'
echo "$clock_speed"
