#!/usr/bin/env python3

from subprocess import check_call
import sys

from github import Github

GH_API_KEY = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

def main():
    gh = Github(GH_API_KEY)
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

    exe_path = f'/tmp/{installer.name}'
    print(f'Downloading {installer.browser_download_url} to {exe_path}')
    check_call(['wget', '-O', exe_path, installer.browser_download_url])
    try:
        check_call(['chmod', '+x', exe_path])
    except Exception as e:
        print(f'WARNING: failed to set {exe_path} as executable')

    ans = input(f'\nDownloaded {installer.name} - launch now? [y/n] ')
    if ans.lower() == 'y':
        check_call(['cygstart', exe_path])


if __name__ == '__main__':
    try:
        main()
    except Exception as e:
        sys.exit(f'Error: {e}')
