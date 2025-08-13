# Setup personal computer

## Stow
```shell
mkdir ~/stow
cd ~/stow
git clone git@192.168.1.213:/srv/git/dotfiles.git
stow dotfiles
```

## Power and performance
### lavd
```shell
echo 'default_sched = "scx_lavd"' | sudo tee /etc/scx_loader.toml
```
### grub
Set GRUB_TIMEOUT=0 and add "amd_pstate=guided" to GRUB_CMDLINE_LINUX in /etc/default/grub.
Then update grub configuration
```shell
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

## systemd
Enable scx_loader and gamemoded services
```shell
systemctl --user enable gamemoded
sudo systemctl enable scx_loader
```

## sshfs
```shell
jellyfin@192.168.1.213: /mnt/nas sshfs allow_other,default_permissions,_netdev,IdentityFile=/home/olive/.ssh/id_ed25519 0 0
```
