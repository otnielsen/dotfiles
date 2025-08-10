#!/bin/dash

# meson is required as well as a compiler and linker for c and c++
# envvars CC, CXX, CXX_LD and CC_LD should be set
# install the build dependencies from ~/.local/share/scripts/requirements/mangohud.txt

set -eu

cd ~/.local/src/MangoHud

compiler_args="-march=native -mtune=native -O3"
builddir=build
meson setup "$builddir" \
    -Dprefix="/usr/local" \
    -Db_lto=true \
    -Db_lto_mode=thin \
    -Dc_args="$compiler_args" \
    -Dcpp_args="$compiler_args" \
    -Dc_link_args="$compiler_args" \
    -Dcpp_link_args="$compiler_args" \
    -Dbuildtype=release \
    -Db_ndebug=if-release \
    -Dwrap_mode=nopromote \
    -Duse_system_spdlog=enabled \
    -Dwith_nvml=disabled \
    -Dwith_xnvctrl=disabled \
    -Dwith_dbus=disabled \
    -Dmangoplot=disabled

# ninja -C "$builddir"
# ninja -C "$builddir" install
