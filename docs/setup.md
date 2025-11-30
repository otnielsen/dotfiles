# Setup personal computer

## Config files
### Stow
```shell
mkdir ~/stow
cd ~/stow
git clone git@192.168.1.213:/srv/git/dotfiles.git
stow dotfiles
```
### System configs
Copy files that go in system directory instead of the home directory.
```shell
~/.config/scripts/system/rsync.sh
```

## Locale and keyboard layout
```shell
sudo localectl set-x11-keymap us '' 'altgr-intl' 'caps:escape'
```

## systemd
Enable scx_loader and gamemoded services
```shell
systemctl --user enable gamemoded
sudo systemctl enable scx_loader
```

## sshfs
```shell
jellyfin@192.168.1.213: /mnt/nas sshfs allow_other,default_permissions,_netdev,x-systemd.automount,IdentityFile=/home/olive/.ssh/id_ed25519 0 0
```
