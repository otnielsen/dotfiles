#!/usr/bin/env sh

export MANGOHUD=1
export RADV_TEX_ANISO=16
export WINE_FULLSCREEN_INTEGER_SCALING=1
export PROTONPATH=proton-cachyos
export PROTON_ENABLE_WAYLAND=1
export PROTON_USE_NTSYNC=1
export PROTON_USE_WOW64=1

exec gamemoderun umu-run "$@"
