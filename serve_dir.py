#! /usr/bin/env python

import argparse
import os
import subprocess
import time

parser = argparse.ArgumentParser()
parser.add_argument('domain')
parser.add_argument('port')
args = parser.parse_args()

# force user to make a domains file
ngrok_domains = None
home = os.path.expanduser('~')
domain_file = os.path.join(home, '.ngrok_domains')
if os.path.isfile(domain_file):
    with open(domain_file) as f:
        ngrok_domains = {line.strip() for line in f}
else:
    raise ValueError(
        '\n\nYou must create a domain file at {} with one domain on each line'.format(domain_file))

# make sure the domain is a valid one
if ngrok_domains:
    if args.domain not in ngrok_domains:
        raise ValueError('\n\nDomains must be one of {}'.format(ngrok_domains))

# start a python simpleserver on pwd
cmd = 'python3 -m http.server {}'.format(args.port)
print(cmd)
p1 = subprocess.Popen(['bash', '-c', cmd])
time.sleep(1)

# start an ngrok server pointed at the simpleserver port
cmd = 'ngrok http -subdomain {} {}'.format(args.domain, args.port)
print(cmd)
p2 = subprocess.Popen(['bash', '-c', cmd])

# will need to hit ctrl-c twice to exit out of this
p1.wait()
p2.wait()

