#!/usr/bin/env sh

set -e

# generate config using /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
