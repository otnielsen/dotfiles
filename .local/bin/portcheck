#!/bin/sh

set -eu

server_local_ip='192.168.1.213'
server_public_ip=$(ssh jellyfin@$server_local_ip 'curl --ipv4 --no-progress-meter https://ip.me')
qbittorrent_port=$(curl --no-progress-meter http://${server_local_ip}:8080/api/v2/app/preferences | jq .listen_port)

nmap -Pn -p "$qbittorrent_port" "$server_public_ip"
