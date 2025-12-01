#!/bin/sh

set -eu

# When governor is changed to performance so is the energy performance
# preference, but when gamemode ends it doesn't restore the epp to
# balance_performance

case "$1" in
gaming) pref=performance ;;
default) pref=default ;;
esac

for epp in /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference; do
    echo "$pref" >"$epp"
done
