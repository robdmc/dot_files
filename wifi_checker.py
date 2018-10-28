#! /usr/bin/env python

import datetime
import os
import sys
import re
import psutil
import subprocess

script_name = os.path.basename(__file__)


def get_process_count():
    p_count = 0
    rex = re.compile(f'^python.*?{script_name}$')
    for p in psutil.process_iter():
        try:
            cmd = ' '.join(p.cmdline())
            if rex.match(cmd):
                p_count += 1
        except psutil.NoSuchProcess:
            continue
    return p_count


def exit_if_running():
    if get_process_count() > 1:
        sys.exit(0)


def wifi_down():
    try:
        subprocess.check_call('curl http://www.google.com'.split())
    except subprocess.CalledProcessError:
        return True
    return False


def restart_wifi():
    with open('/home/rob/var/log/wifi_restart.log', 'w') as out:
        now = datetime.datetime.now()
        print(f'Restarting wifi at {now}', file=out)
    subprocess.check_call('bash /home/rob/bin/fixwifi.sh'.split())


def main():
    exit_if_running()
    if wifi_down():
        restart_wifi()


if __name__ == '__main__':
    main()