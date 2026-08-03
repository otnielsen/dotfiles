#!/bin/sh

set -eu

case "$1" in
gaming)
    pref=performance
    profile=1
    ;;
balanced)
    pref=balance_power
    profile=2
    ;;
esac

for epp in /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference; do
    echo "$pref" >"$epp"
done

card=$(udevadm trigger --dry-run --verbose \
    --subsystem-match=pci \
    --property-match=DRIVER=amdgpu \
    --attr-match=unique_id=22190ab2d9cbbf14)
profile_file="$card/pp_power_profile_mode"

if [ -d "$card" ] && [ -f "$profile_file" ]; then
    echo "$profile" >"$profile_file"
fi
