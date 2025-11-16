#!/bin/sh

set -eu

script_dir=$(realpath "$(dirname "$0")")

sudo -k rsync -rvu --exclude-from="$script_dir/.rsyncignore" "$script_dir/" /
