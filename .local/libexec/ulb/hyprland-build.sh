#!/bin/dash

set -eu

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
    -Dwrap_mode=nofallback \
    -Dbuildtype=release \
    -Db_ndebug=if-release \
    -Dxwayland=enabled \
    -Dsystemd=disabled \
    -Duwsm=disabled \
    -Dhyprpm=disabled
