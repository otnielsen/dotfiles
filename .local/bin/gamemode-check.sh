#!/bin/sh

set -eu

gamemoded -s
scxctl get

printf 'hidecursor loaded? '
busctl --user call org.kde.KWin /Effects org.kde.kwin.Effects isEffectLoaded s hidecursor | awk '{ print $2 }'

printf 'governor: '
cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor | sort -u

printf 'epp: '
cat /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference | sort -u
