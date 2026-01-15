#!/bin/sh

set -eu

gateway='10.2.0.1'
interface='wg0'

wg show interfaces | grep -xq "$interface" || wg-quick up "$interface"

while true; do
    if fping -q $gateway; then
        natpmpc -g $gateway -a 1 0 tcp
        listen_port=$(natpmpc -g $gateway -a 1 0 udp | awk '/^Mapped public port/ { print $4; exit }')

        # only update qbittorrent listening port if it differs from the mapping by natpmpc
        if [ "$(curl --no-progress-meter http://localhost:8080/api/v2/app/preferences | jq .listen_port)" != "$listen_port" ]; then
            curl --no-progress-meter -d "json={\"listen_port\": $listen_port}" http://localhost:8080/api/v2/app/setPreferences
        fi
    else
        wg show interfaces | grep -xq "$interface" && wg-quick down "$interface"
        fping -q ip.me && wg-quick up "$interface"
    fi
    sleep 45
done
