#!/usr/bin/env sh

# meson is required as well as a compiler and linker for c and c++
# envvars CC, CXX, CXX_LD and CC_LD should be set
# install the build dependencies from ~/.local/share/scripts/requirements/mesa.txt

set -e

if [ -z "$1" ]; then
    # download list of tags and set version to newest
    mesa_ver=$(curl "https://gitlab.freedesktop.org/api/v4/projects/mesa%2Fmesa/repository/tags" | jq -r 'map(.name) | sort | .[-1]')
else
    mesa_ver="$1"
fi

cd ~/.local/src

if [ -d "$mesa_ver" ]; then
    echo "$mesa_ver is already downloaded."
    exit 1
fi

curl -fOL "https://archive.mesa3d.org/${mesa_ver}.tar.xz"
tar -xf "${mesa_ver}.tar.xz"
rm "${mesa_ver}.tar.xz"
cd "$mesa_ver"

compiler_args="-march=native -mtune=native -O3"
builddir=build
meson setup "$builddir" \
    -Dprefix="$HOME/.local" \
    -Dvulkan-drivers=amd \
    -Dgallium-drivers=radeonsi \
    -Dplatforms=wayland,x11 \
    -Db_lto=true \
    -Db_lto_mode=thin \
    -Dvideo-codecs=all \
    -Dc_args="$compiler_args" \
    -Dcpp_args="$compiler_args" \
    -Dc_link_args="$compiler_args" \
    -Dcpp_link_args="$compiler_args" \
    -Dllvm=disabled \
    -Dwrap_mode=nofallback \
    -Dbuildtype=release \
    -Db_ndebug=if-release \
    -Damd-use-llvm=false \
    -Dgallium-vdpau=enabled \
    -Dgallium-va=enabled

ulimit -n 2048 # mold complains about too many open files with the default 1024
ninja -C "$builddir"
ninja -C "$builddir" install
