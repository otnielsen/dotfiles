#!/bin/dash

set -eu

version=$(curl -fL --no-progress-meter https://api.github.com/repos/gokcehan/lf/releases/latest | jq -r '.tag_name')

if [ "$version" = "$(lf --version)" ]; then
    echo "lf $version is already installed."
    exit
fi

cd ~/.local/bin

archive_name="lf-linux-amd64.tar.gz"
curl -fOL "https://github.com/gokcehan/lf/releases/download/${version}/$archive_name"
tar -xf "$archive_name"
rm "$archive_name"
