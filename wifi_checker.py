#! /usr/bin/python3

import datetime
import os
import sys
import re
import psutil
import subprocess
import time

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


def restart_wifi(now):
    print(f'Restarting wifi at {now}')
    subprocess.check_call('bash /home/rob/bin/fixwifi.sh'.split())
    print(f'Restart successful')


def main():
        now = datetime.datetime.now()
        print(f'Checking wifi at {now}')
        exit_if_running()
        if wifi_down():
            restart_wifi(now)


if __name__ == '__main__':
    while True:
        main()
        sys.stdout.flush()
        time.sleep(60)
