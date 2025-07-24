#!/usr/bin/env sh

set -e

# get clock speed first so retrieval of information doesn't affect it
clock_speed=$(grep MHz /proc/cpuinfo)

gamemoded -s
scxctl get

echo '#### governor ####'
cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor

echo '#### cpu clock ####'
echo "$clock_speed"
