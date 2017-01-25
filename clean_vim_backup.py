#! /usr/bin/env python
from __future__ import print_function

import os
import glob
from datetime import datetime, timedelta

# find the oldest allowable day
now = datetime.now()
oldest_day = now - timedelta(days=30)


# find all files in the backup directory
files = glob.glob(os.path.expanduser('~/.vim_backups/*'))

# ignore symlinks
files = (f for f in files if not os.path.islink(f))

# limit to old files
files = (
    f for f in files
    if datetime.fromtimestamp(os.path.getctime(f)) < oldest_day
)

# delete old files
for f in files:
    os.remove(f)
