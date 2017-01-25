#! /usr/bin/env python

from __future__ import print_function
import os
import platform
import sys

def run_command(cmd, msg='failed'):
    print(cmd)
    if os.system(cmd):
        sys.stderr.write('\n\n{}\n\n'.format(msg))
        sys.exit(1)

if not os.path.isfile(os.path.expanduser('~/bin/ngrok')):
    platform_info = platform.platform().lower()
    if 'darwin' in platform_info:
        cmd = 'cd ~/bin '
        cmd += ' && wget \'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-darwin-amd64.zip\''
        cmd += ' && unzip ngrok-stable-darwin-amd64.zip'
        cmd += ' && rm ngrok-stable-darwin-amd64.zip'
        run_command(cmd)

    elif 'linux' in platform_info:
        cmd = 'cd ~/bin '
        cmd += ' && wget \'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip\''
        cmd += ' && unzip ngrok-stable-linux-amd64.zip'
        cmd += ' && rm ngrok-stable-linux-amd64.zip'
        run_command(cmd)

    else:
        sys.stderr.write('\n\nArchitechure not recognized')
        sys.exit(1)

cmd = "p.crypt -i ngrok_config.tar.crypt -o ngrok_config.tar -d"
run_command(cmd)

cmd = "cd ~ && tar -xvf ./dot_files/ngrok_config.tar"
run_command(cmd)


