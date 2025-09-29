#!/bin/sh

set -eu

gateway='10.2.0.1'
while true; do
    if fping -q $gateway; then
        natpmpc -g $gateway -a 1 0 tcp
        listen_port=$(natpmpc -g $gateway -a 1 0 udp | awk '/^Mapped public port/ { print $4; exit }')
        curl --no-progress-meter -d "json={\"listen_port\": $listen_port}" http://localhost:8080/api/v2/app/setPreferences
    fi
    sleep 45
done
