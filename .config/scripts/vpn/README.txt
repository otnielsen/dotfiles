This is a systemd service that forwards a port on the vpn server and updates
the listening port in qbittorrent. Move the files to the server running
qbittorrent and enable the service.

Where to place the files on the server:
portforward.service --> /usr/local/lib/systemd/system/portforward.service
portforward.sh --> /usr/local/bin/portforward.sh
