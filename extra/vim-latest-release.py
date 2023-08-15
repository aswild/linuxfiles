#!/usr/bin/env python3

"""
Use GitHub's API to find and download the latest signed 64-bit windows gvim
installer from the vim-win32-installer repo.

This script requires python >=3.7, the github module, and optionally the wslvar,
wslpath, and wslview programs from the "wslu" package.
"""

import subprocess
import os
import sys

from github import Github

def cmd_output(*cmd):
    res = subprocess.run(cmd, stdout=subprocess.PIPE, check=True, text=True)
    return res.stdout.strip()

def get_tmpdir():
    if os.path.exists('/mnt/wsl'):
        try:
            temp_win = cmd_output('wslvar', 'TEMP')
            temp_linux = cmd_output('wslpath', temp_win)
            tmpdir = temp_linux
            assert os.path.isdir(tmpdir)
        except:
            print('Warning: failed to get WSL host TEMP directory')
            tmpdir = '/tmp'
    else:
        tmpdir = '/tmp'
    assert os.path.isdir(tmpdir), f"tmpdir '{tmpdir}' doesn't exist"
    return tmpdir

def main():
    gh = Github()
    repo = gh.get_repo('vim/vim-win32-installer')
    installer = None
    for rel in repo.get_releases():
        for a in rel.get_assets():
            if a.name.endswith('x64_signed.exe'):
                installer = a
                break
        if installer is not None:
            break
    if installer is None:
        raise Exception('No x86_signed.exe releases found')

    exe_path = os.path.join(get_tmpdir(), installer.name)
    print(f'Downloading {installer.browser_download_url} to {exe_path}')
    subprocess.run(['wget', '-O', exe_path, installer.browser_download_url], check=True)

    ans = input(f'\nDownloaded {installer.name} - launch now? [y/n] ')
    if ans.lower() == 'y':
        subprocess.run(['wslview', exe_path])


if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        sys.exit(f'Error: {e}')
