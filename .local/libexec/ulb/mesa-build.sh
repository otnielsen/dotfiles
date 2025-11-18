#!/bin/dash

# meson is required as well as a compiler and linker for c and c++
# envvars CC, CXX, CXX_LD and CC_LD should be set
# install the build dependencies from ~/.local/share/scripts/requirements/mesa.txt

set -eu

# download list of tags and use version sort with tilde substitution (so first stable release comes after last rc)
version=$(curl -fL --no-progress-meter "https://gitlab.freedesktop.org/api/v4/projects/mesa%2Fmesa/repository/tags" | jq -r 'map(.name) | .[]' | sed 's/-rc/~-rc/' | sort -V | tail -n 1 | sed 's/~-rc/-rc/; s/^mesa-//')

if [ "$version" = "$(vulkaninfo --summary | awk '/driverInfo/ { print $4; exit }')" ]; then
    echo "Mesa $version is already installed."
    exit
fi

cd ~/.local/src

archive_name="mesa-${version}.tar.xz"
curl -fOL "https://archive.mesa3d.org/$archive_name"
tar -xf "$archive_name"
rm "$archive_name"
cd "mesa-$version"

compiler_args="-march=native -mtune=native -O3"
builddir=build
meson setup "$builddir" \
    -Dprefix=/usr/local \
    -Dvulkan-drivers=amd \
    -Dgallium-drivers=radeonsi \
    -Dplatforms=wayland,x11 \
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
    -Dgallium-va=enabled

ulimit -n 2048 # mold complains about too many open files with the default 1024
ninja -C "$builddir"
sudo ninja -C "$builddir" install
sudo find /usr/local/lib64 -maxdepth 1 -name "libgallium-*.so" '!' -name "libgallium-${version}.so" -type f -delete
