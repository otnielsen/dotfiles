#!/usr/bin/env python3

import os
import pwd
import sys
from pathlib import Path

if os.geteuid() != 0:
    sys.exit('Must be run as root.')

try:
    home_dir = pwd.getpwnam(sys.argv[1]).pw_dir
except KeyError:
    sys.exit(f"User '{sys.argv[1]}' doesn't exist on the system.")
except IndexError:
    sys.exit('A user name must be passed as the first argument.')


home_path = Path(
    f'{home_dir}/.local/state/nix/profiles/home-manager/home-path'
).resolve(strict=True)
profile_link = Path('/nix/var/nix/profiles/home-manager-path')
profile_link.unlink(missing_ok=True)
profile_link.symlink_to(home_path)


def symlink_program_files(dir: str | Path):
    target_dir = profile_link / dir
    link_dir = Path('/usr/local') / target_dir.relative_to(
        profile_link, walk_up=False
    )
    link_dir.mkdir(parents=True, exist_ok=True)

    for root, _, files in target_dir.walk(
        top_down=True, follow_symlinks=False
    ):
        for name in files:
            target = root / name
            link = Path('/usr/local') / target.relative_to(
                profile_link, walk_up=False
            )

            link.unlink(missing_ok=True)
            link.symlink_to(target)

    for root, _, files in link_dir.walk(top_down=True, follow_symlinks=False):
        for name in files:
            file = root / name
            if not file.exists(follow_symlinks=True):
                file.unlink()


symlink_program_files('lib/sysusers.d')
symlink_program_files('lib/tmpfiles.d')
symlink_program_files('share/polkit-1/actions')
symlink_program_files('share/polkit-1/rules.d')


system_config = Path(f'{home_dir}/dotfiles/system')


def copy_system_config(dir: str | Path):
    dir = system_config / dir
    for root, _, files in dir.walk(top_down=True, follow_symlinks=False):
        for name in files:
            source = root / name
            dest = Path('/') / source.relative_to(system_config, walk_up=False)

            try:
                if source.lstat().st_mtime > dest.lstat().st_mtime:
                    dest.unlink()
                    source.copy(
                        dest, follow_symlinks=False, preserve_metadata=True
                    )
            except FileNotFoundError:
                dest.parent.mkdir(parents=True, exist_ok=True)
                source.copy(
                    dest, follow_symlinks=False, preserve_metadata=True
                )


copy_system_config('etc')
copy_system_config('usr/local')
