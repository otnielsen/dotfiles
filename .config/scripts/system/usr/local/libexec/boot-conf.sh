#!/bin/sh

# script to run on system boot

# use amd p-state guided autonomous mode
echo guided >/sys/devices/system/cpu/amd_pstate/status
