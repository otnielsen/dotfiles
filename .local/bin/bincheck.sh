#!/bin/sh

set -eu

exit_status=0
for bin in $(jq -r .[] ~/.config/scripts/setup/dependencies.json); do
    command -v "$bin" >/dev/null 2>&1 || { echo "$bin cannot be found in \$PATH" && exit_status=1; }
done

exit $exit_status
