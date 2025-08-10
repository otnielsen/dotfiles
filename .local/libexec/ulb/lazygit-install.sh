#!/bin/dash

set -eu

version=$(curl -fL --no-progress-meter https://api.github.com/repos/jesseduffield/lazygit/releases/latest | jq -r '.tag_name' | sed 's/^v//')

if [ "$version" = "$(lazygit --version | awk -F ',' '{ sub(/^ version=/, "", $4); print $4 }')" ]; then
    echo "lazygit $version is already installed."
    exit
fi

cd ~/.local/bin

archive_name="lazygit_${version}_linux_x86_64.tar.gz"
curl -fL --remote-name-all "https://github.com/jesseduffield/lazygit/releases/download/v${version}/{$archive_name,checksums.txt}"
sha256sum -c --ignore-missing --quiet --strict checksums.txt
tar -xf "$archive_name" lazygit
rm "$archive_name"
