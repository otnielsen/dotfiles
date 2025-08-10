#!/bin/dash

# The following submodules are needed:
# - Externals/implot/implot
# - Externals/tinygltf/tinygltf
# - Externals/SFML/SFML
# The dnf dependencies are in ~/.local/share/scripts/requirements/dolphin.txt

set -eu

cd ~/.local/src/dolphin

git submodule update --init Externals/implot/implot Externals/tinygltf/tinygltf Externals/SFML/SFML

compiler_args="-march=native -mtune=native -O3 -flto=thin"
cmake -B build -G Ninja \
    -DENABLE_CLI_TOOL=OFF \
    -DUSE_UPNP=OFF \
    -DENABLE_NOGUI=OFF \
    -DENABLE_ALSA=OFF \
    -DENABLE_CUBEB=OFF \
    -DENABLE_LLVM=OFF \
    -DENABLE_TESTS=OFF \
    -DUSE_DISCORD_PRESENCE=OFF \
    -DUSE_MGBA=OFF \
    -DENABLE_AUTOUPDATE=OFF \
    -DUSE_RETRO_ACHIEVEMENTS=OFF \
    -DENABLE_ANALYTICS=OFF \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_LINKER_TYPE=MOLD \
    -DCMAKE_C_FLAGS="$compiler_args" \
    -DCMAKE_CXX_FLAGS="$compiler_args"
