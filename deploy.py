#! /usr/bin/env python

from __future__ import print_function
import textwrap
import os

FILE_PATH = os.path.dirname(__file__)


class Deploy(object):
    # (source, target)
    FILES_TO_LINK = [
        # Dot files
        ('~/dot_files/.bash_profile', '~/.bash_profile'),
        ('~/dot_files/.bashrc', '~/.bashrc'),
        ('~/dot_files/.inputrc', '~/.inputrc'),
        ('~/dot_files/.vim', '~/.vim'),
        ('~/dot_files/.vimrc', '~/.vimrc'),
        ('~/dot_files/.ideavimrc', '~/.ideavimrc'),
        ('~/dot_files/.ackrc', '~/.ackrc'),
        ('~/dot_files/.ctags', '~/.ctags'),
        ('~/dot_files/rcconda.sh', '~/rcconda.sh'),
        ('~/dot_files/gitignore_global', '~/.gitignore_global')
        ('~/dot_files/flake8', '~/.config/flake8')

        # Executables
        ('~/dot_files/git_diff_wrapper', '~/bin/git_diff_wrapper'),
        ('~/dot_files/git_branch_diff', '~/bin/git_branch_diff'),
        ('~/dot_files/circle_checker', '~/bin/circle_checker'),
        ('~/dot_files/serve_dir.py', '~/bin/serve_dir.py'),
        ('~/dot_files/imgcat', '~/bin/imgcat'),
        ('~/dot_files/make_tags', '~/bin/make_tags'),
        ('~/dot_files/clean_vim_backup.py', '~/bin/clean_vim_backup.py'),
        ('~/dot_files/diffconflicts', '~/bin/diffconflicts'),
        ('~/dot_files/myip', '~/bin/myip'),

    ]

    PATHS_TO_CREATE = [
        '~/bin',
        '~/.undodir',
        '~/.config',
    ]

    def __init__(self, kind, dry_run=False, use_gnu_tools=True):
        self.kind = kind
        self.dry_run = dry_run
        self.use_gnu_tools = True

    def run(self):
        self.create_paths()
        self.make_file_links()
        self.make_git_config()
        self.ensure_bash_history()

    def create_paths(self):
        for path in self.PATHS_TO_CREATE:
            path = os.path.expanduser(path)
            if not os.path.isdir(path):
                if self.dry_run:
                    print('mkdir -p {}'.format(path))
                else:
                    os.makedirs(path)

    def make_file_links(self):
        for (source_name, target_name) in self.FILES_TO_LINK:
            src = os.path.expanduser(source_name)
            tgt = os.path.expanduser(target_name)
            cmd = 'ln -sf {src} {tgt}'.format(src=src, tgt=tgt)

            print(cmd)
            if not self.dry_run:
                os.system(cmd)

    def ensure_bash_history(self):
        history_file = os.path.isfile(os.path.expanduser('~/.bash_history'))
        if not os.path.isfile(history_file):
            cmd = 'cp ~/dot_files/fake_bash_history {}'.format(history_file)
            print(cmd)
            if not self.dry_run:
                os.system(cmd)

    def make_git_config(self):
        if self.kind == 'personal':
            context = dict(
                name='Rob deCarvalho',
                email='robdmc@gmail.com',
                github_user_spec=textwrap.dedent(
                    """
                    [github]
                        user = robdmc
                    """
                )
            )
        else:
            context = dict(
                name='Generic User',
                email='generic@user.net',
                github_user_spec='',
            )

        with open(os.path.join(FILE_PATH, 'gitconfig_template')) as f:
            template = f.read()
            contents = template.format(**context)

        if self.dry_run:
            print('=' * 40 + ' .git_config ' + '=' * 40)
            print(contents)
            print('=' * 40 + ' end .git_config ' + '=' * 40)
        else:
            with open(os.path.expanduser('~/.gitconfig', 'w')) as out:
                out.write(contents)

deploy = Deploy('generic', dry_run=True, use_gnu_tools=True)
deploy.run()
