#! /usr/bin/env python

from __future__ import print_function
import os
import platform
import sys


cmd = "p.crypt -i ngrok_config.tar.crypt -o ngrok_config.tar -d"
print(cmd)
if os.system(cmd):
    print('failed', sys.stderr)
    sys.exit()

cmd = "cd ~ && tar -xvf ./dot_files/ngrok_config.tar"
print(cmd)
if os.system(cmd):
    print('failed', sys.stderr)
    sys.exit()


platform_info = platform.platform().lower()
if 'darwin' in platform_info:
    cmd = 'cd ~/bin '
    cmd += ' && wget \'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-darwin-amd64.zip\''
    cmd += ' && unzip ngrok-stable-darwin-amd64.zip'
    cmd += ' && rm ngrok-stable-darwin-amd64.zip'
    if os.system(cmd):
        print('failed', sys.stderr)
        sys.exit()

elif 'linux' in platform_info:
    cmd = 'cd ~/bin '
    cmd += ' && wget \'https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip\''
    cmd += ' && unzip ngrok-stable-linux-amd64.zip'
    cmd += ' && rm ngrok-stable-linux-amd64.zip'
    if os.system(cmd):
        print('failed', sys.stderr)
        sys.exit()

else:
    print('\n\nArchitechure not recognized', sys.stderr)

