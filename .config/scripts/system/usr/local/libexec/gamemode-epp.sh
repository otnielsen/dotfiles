#!/bin/sh

set -eu

case "$1" in
gaming) pref=performance ;;
balanced) pref=balance_power ;;
esac

for epp in /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference; do
    echo "$pref" >"$epp"
done
