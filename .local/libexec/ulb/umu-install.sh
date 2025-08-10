#!/bin/dash

set -eu

version=$(curl -fL --no-progress-meter https://api.github.com/repos/Open-Wine-Components/umu-launcher/releases/latest | jq -r '.tag_name')

if [ "$version" = "$(umu-run --version | awk '{ print $3 }')" ]; then
    echo "umu $version is already installed."
    exit
fi

cd ~/.local/bin

archive_name="umu-launcher-${version}-zipapp.tar"
curl -fOL "https://github.com/Open-Wine-Components/umu-launcher/releases/download/${version}/$archive_name"
tar --strip-components=1 -xf "$archive_name" umu/umu-run
rm "$archive_name"
