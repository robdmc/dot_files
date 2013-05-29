#! /usr/bin/env python
import os
import sys
import re


home = os.getenv('HOME')
inFileName = os.path.join(home, '.bash_history')
outFileName = os.path.join(home, '.zsh_history')



rex = re.compile(r'^#(\d+$)')

with open(inFileName) as inFile:
    with open(outFileName, 'w') as outFile:

        timeTag, cmd = '',''
        for line in inFile:
            m = rex.match(line)
            if m:
                timeTag = m.group(1).strip()
            else:
                cmd = line.strip()
                if timeTag:
                    outFile.write(': %s:0;%s\n' % (timeTag, cmd))
                    print ': %s:0;%s' % (timeTag, cmd)
                    timeTag, cmd = '', ''

