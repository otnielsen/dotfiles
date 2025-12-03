#!/bin/sh

# script to run on system boot

for epp in /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference; do
    echo power >"$epp"
done
