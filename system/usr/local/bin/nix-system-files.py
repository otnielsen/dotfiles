#!/usr/bin/env python3

import argparse
import hashlib
import json
import os
import pwd
import re
import shutil
import sys
from pathlib import Path

if os.geteuid() != 0:
    sys.exit('Must be run as root.')

parser = argparse.ArgumentParser()
parser.add_argument('user')
parser.add_argument('store_path', type=Path, metavar='store-path', nargs='?')
parser.add_argument(
    '-f', '--force', help='force install nix store files', action='store_true'
)
args = parser.parse_args()

USER = args.user
STORE_PATH: Path | None = args.store_path

USR_LOCAL = Path('/usr/local')
ETC = Path('/etc')

try:
    home_dir = pwd.getpwnam(USER).pw_dir
except KeyError:
    sys.exit(f"User '{USER}' doesn't exist on the system.")


def copy_system_config(dir: Path):
    for root, _, files in dir.walk(top_down=True, follow_symlinks=False):
        for name in files:
            src = root / name
            dest = Path('/') / src.relative_to(dir, walk_up=False)

            try:
                if src.lstat().st_mtime > dest.lstat().st_mtime:
                    dest.unlink()
                    src.copy(
                        dest, follow_symlinks=False, preserve_metadata=True
                    )
            except FileNotFoundError:
                dest.parent.mkdir(parents=True, exist_ok=True)
                src.copy(dest, follow_symlinks=False, preserve_metadata=True)


def install_program_files(new_env: Path, old_manifest: dict):
    new_manifest = {}

    for root, dirs, files in new_env.walk(top_down=True, follow_symlinks=True):
        if root.full_match(new_env):
            for dir in (
                'bin',
                'sbin',
            ):
                try:
                    dirs.remove(dir)
                except ValueError:
                    pass

        elif root.full_match(f'{new_env}/share'):
            for dir in (
                'applications',
                'bash-completion',
                'dbus-1',
                'fonts',
                'gamemode',
                'icons',
                'locale',
                'man',
                'systemd',
            ):
                try:
                    dirs.remove(dir)
                except ValueError:
                    pass

        elif root.full_match(f'{new_env}/etc/**'):
            rel_dir = root.relative_to(new_env / 'etc', walk_up=False)
            link_dir = ETC / rel_dir
            link_dir.mkdir(parents=True, exist_ok=True)

            for name in files:
                target = root / name
                link = link_dir / name

                if (not link.exists(follow_symlinks=True)) or (
                    link.is_symlink()
                    and str(link) in old_manifest
                    and str(link.readlink()) == old_manifest[str(link)]
                ):
                    link.unlink(missing_ok=True)
                    link.symlink_to(target)
                    new_manifest[str(link)] = str(target)
                else:
                    print(f'Not overwriting admin configuration at {link}')

        elif root.full_match(f'{new_env}/lib/systemd/**'):
            dest_dir = (
                USR_LOCAL
                / 'lib/systemd'
                / root.relative_to(new_env / 'lib/systemd', walk_up=False)
            )
            dest_dir.mkdir(parents=True, exist_ok=True)

            for name in files:
                src = root / name
                dest = dest_dir / name

                with src.open('rb') as f:
                    src_digest = hashlib.file_digest(f, 'sha256')
                src_hash = src_digest.hexdigest()

                try:
                    with dest.open('rb') as f:
                        dest_digest = hashlib.file_digest(f, 'sha256')
                    dest_hash = dest_digest.hexdigest()
                except FileNotFoundError:
                    dest_hash = None
                except IsADirectoryError:
                    if dest.is_symlink():
                        dest.unlink()
                    else:
                        shutil.rmtree(dest)
                    dest_hash = None

                if src_hash != dest_hash:
                    src.copy(
                        dest, follow_symlinks=True, preserve_metadata=True
                    )

                new_manifest[str(dest)] = str(src)

        else:
            link_dir = USR_LOCAL / root.relative_to(new_env, walk_up=False)
            link_dir.mkdir(parents=True, exist_ok=True)

            for name in files:
                target = root / name
                link = link_dir / name
                link.unlink(missing_ok=True)
                link.symlink_to(target)
                new_manifest[str(link)] = str(target)

    old_files = old_manifest.keys() - new_manifest.keys()
    for file in old_files:
        path = Path(file)

        if path.full_match('/etc/**') and not (
            path.is_symlink() and str(path.readlink()) == old_manifest[file]
        ):
            continue

        path.unlink(missing_ok=True)

    return new_manifest


system_config = Path(f'{home_dir}/dotfiles/system')
copy_system_config(system_config)


# https://nix.dev/manual/nix/latest/protocols/nix32.html
store_pattern = re.compile(r'/nix/store/[0-9a-df-np-sv-z]{32}-system-pkgs')

if (
    STORE_PATH
    and store_pattern.fullmatch(str(STORE_PATH))
    and STORE_PATH.is_dir()
):
    store_link = Path(f'/opt/hm-system-pkgs/{USER}/system-pkgs')
    try:
        old_env = store_link.readlink()
    except OSError:
        old_env = None

    if STORE_PATH != old_env or args.force:
        manifest_file = Path(
            f'/opt/hm-system-pkgs/{USER}/install_manifest.json'
        )

        try:
            with manifest_file.open() as f:
                manifest = json.load(f)

        except FileNotFoundError:
            manifest = {}

        installed_files = install_program_files(STORE_PATH, manifest)

        manifest_file.parent.mkdir(parents=True, exist_ok=True)
        with manifest_file.open('w') as f:
            json.dump(installed_files, f, indent=2)

        store_link.unlink(missing_ok=True)
        store_link.symlink_to(STORE_PATH)

    else:
        print('system-pkgs environment is unchanged.')

else:
    print('Not installing nix store files.')
