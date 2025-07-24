#!/usr/bin/env sh

# meson is required as well as a compiler and linker for c and c++
# envvars CC, CXX, CXX_LD and CC_LD should be set
# install the build dependencies from ~/.local/share/scripts/requirements/gamemode.txt

set -e

if [ -z "$1" ]; then
    gamemode_ver=$(curl https://api.github.com/repos/FeralInteractive/gamemode/releases/latest | jq -r .tag_name)
else
    gamemode_ver="$1"
fi

cd ~/.local/src

if [ -d "gamemode-${gamemode_ver}" ]; then
    echo "gamemode-${gamemode_ver} is already downloaded."
    exit 1
fi

curl -fOL "https://github.com/FeralInteractive/gamemode/releases/download/${gamemode_ver}/gamemode-${gamemode_ver}.tar.xz"
tar -xf "gamemode-${gamemode_ver}.tar.xz"
rm "gamemode-${gamemode_ver}.tar.xz"
cd "gamemode-${gamemode_ver}"

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
