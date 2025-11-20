#!/bin/dash

set -eu

version=$(curl -fL --no-progress-meter https://api.github.com/repos/CachyOS/proton-cachyos/releases/latest | jq -r '.tag_name')

if [ "$version" = "$(awk '{ print $2 }' "$HOME"/.local/share/Steam/compatibilitytools.d/proton-cachyos/version)" ]; then
    echo "proton $version is already installed."
    exit
fi

cd ~/.local/share/Steam/compatibilitytools.d

base_name="proton-$version-x86_64_v4"
archive_name="${base_name}.tar.xz"
checksum_file_name="${base_name}.sha512sum"
curl -fL --remote-name-all "https://github.com/CachyOS/proton-cachyos/releases/download/${version}/{$archive_name,$checksum_file_name}"
sha512sum -c --ignore-missing --quiet --strict "$checksum_file_name"
tar -xf "$archive_name"
rm "$archive_name" "$checksum_file_name"
ln -snf "$base_name" proton-cachyos
find . -maxdepth 1 -name "proton-cachyos-*-slr-x86_64_v4" '!' -name "$base_name" -type d -delete
