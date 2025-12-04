#!/bin/sh

set -eu

# When governor is changed to performance so is the energy performance
# preference, but when gamemode ends it doesn't restore the epp to
# balance_performance

# case "$1" in
# gaming) pref=performance ;;
# default) pref=power ;;
# esac
#
# for epp in /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference; do
#     echo "$pref" >"$epp"
# done

# change pstate mode but not governor. guided is better for gaming, while
# passive is better for energy saving during normal use
case "$1" in
gaming) pref=guided ;;
default) pref=passive ;;
*) exit 1 ;;
esac

echo "$pref" >/sys/devices/system/cpu/amd_pstate/status
