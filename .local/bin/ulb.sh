#!/bin/dash

# ulb - update local builds

set -eu

for build_script in ~/.local/libexec/ulb/*; do
    if [ -x "$build_script" ]; then
        "$build_script"
    fi
done
