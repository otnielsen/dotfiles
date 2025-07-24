#!/usr/bin/env sh

set -e

gamemoded -s
scxctl get

echo '#### governor ####'
cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor

echo '#### cpu clock ####'
grep MHz /proc/cpuinfo
