#!/bin/sh

set -eu

if [ "$(id -u)" != "0" ]; then
    echo "Must be run as root." >&2
    exit 1
fi

user="$1"

id "$user" >/dev/null || exit 1

rsync -rlptv "/home/$user/dotfiles/system/" /
