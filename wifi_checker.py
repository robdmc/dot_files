#! /usr/bin/python3

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
        subprocess.check_call(
            'curl http://www.google.com'.split(),
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
    except subprocess.CalledProcessError:
        return True
    return False


def restart_wifi(out, now):
    print(f'Restarting wifi at {now}', file=out)
    subprocess.check_call('bash /home/rob/bin/fixwifi.sh'.split())
    print(f'Restart successful', file=out)


def main():
        now = datetime.datetime.now()
        with open('/home/rob/var/log/wifi_restart.log', 'w') as out:
            print(f'Checking wifi at {now}', file=out)
            exit_if_running()
            if wifi_down():
                restart_wifi(out, now)


if __name__ == '__main__':
    main()
