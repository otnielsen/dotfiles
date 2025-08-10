#!/bin/dash

# meson is required as well as a compiler and linker for c and c++
# envvars CC, CXX, CXX_LD and CC_LD should be set
# install the build dependencies from ~/.local/share/scripts/requirements/gamemode.txt

set -eu

version=$(curl -fL --no-progress-meter https://api.github.com/repos/FeralInteractive/gamemode/releases/latest | jq -r '.tag_name')

if [ "$version" = "$(gamemoded --version | awk '{ sub(/^v/, "", $3); print $3 }')" ]; then
    echo "Gamemode $version is already installed."
    exit
fi

cd ~/.local/src

archive_name="gamemode-${version}.tar.xz"
curl -fL --remote-name-all "https://github.com/FeralInteractive/gamemode/releases/download/${version}/{$archive_name,sha256sums.txt}"
sha256sum -c --ignore-missing --quiet --strict sha256sums.txt
tar -xf "$archive_name"
rm "$archive_name"
cd "gamemode-$version"

compiler_args="-march=native -mtune=native -O3"
builddir=build
# prefix is /usr/local (the default) so polkit works
meson setup "$builddir" \
    -Dprefix=/usr/local \
    -Db_lto=true \
    -Db_lto_mode=thin \
    -Dc_args="$compiler_args" \
    -Dc_link_args="$compiler_args" \
    -Dwrap_mode=nofallback \
    -Dbuildtype=release \
    -Db_ndebug=if-release

ninja -C "$builddir"
sudo ninja -C "$builddir" install
