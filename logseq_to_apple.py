#! /Users/rob/envs/base/bin/python

import os
import datetime

print('\n\n')
print('=' * 80)
print(str(datetime.datetime.now()))
print('=' * 80)


target_logseq_dir = (
    '/Users/rob/Library/Mobile Documents/iCloud~com~logseq~logseq/Documents'
)

directories_to_sync = [
    '/Users/rob/rob/repos/ambition_logseq',
    '/Users/rob/rob/repos/personal_logseq',
    '/Users/rob/rob/repos/references_logseq',
    '/Users/rob/rob/repos/renovation_logseq',
    '/Users/rob/rob/repos/consulting_logseq',
]

subdirs_to_sync = [
    'assets',
    'draws',
    'journals',
    'pages',
]


purge_subdir = 'logseq'
purge_dir = os.path.join(target_logseq_dir, purge_subdir)
if os.path.isdir(purge_dir) and os.listdir(purge_dir):
    cmd = f'rm -rf {purge_dir!r}/*'
    print(cmd)
    os.system(cmd)


for path in directories_to_sync:
    for subdir in subdirs_to_sync:
        full_source_path = os.path.join(path, subdir)
        if not os.path.isdir(full_source_path):
            continue
        full_target_path = os.path.join(target_logseq_dir, subdir)
        if not os.path.isdir(full_source_path):
            print('need to make', full_target_path)
        cmd = f'rsync -a {full_source_path!r}/ {full_target_path!r}'
        print(cmd)
        os.system(cmd)
