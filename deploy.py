#! /usr/bin/env python

from __future__ import print_function
import textwrap
import os

FILE_PATH = os.path.dirname(__file__)


class Deploy(object):
    FILES_TO_LINK = [
        '.bash_profile',
        '.bashrc',
        '.inputrc',
        '.vim',
        '.vimrc',
        '.ideavimrc',
        '.ackrc',
        '.ctags',
        'rcconda.sh',
    ]

    def __init__(self, kind, dry_run=False):
        self.kind = kind
        self.dry_run = dry_run

    def make_file_links(self):
        for file_name in self.FILES_TO_LINK:
            cmd = 'cd ~; ln -sf ./dot_files/{} .'.format(file_name)
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
        print(contents)




deploy = Deploy('generic', dry_run=True)
deploy.make_git_config()









## --- link the .gitconfig file
#cmd = "cd ~; ln -sf ./dot_files/gitconfig .gitconfig"
#print(cmd)
#os.system(cmd)
#
## --- link the .gitignore file
#cmd = "cd ~; ln -sf ./dot_files/gitignore_global .gitignore_global"
#print(cmd)
#os.system(cmd)
#
#
## --- if a home/bin directory doesnt exist, create it
#binDir = os.path.join(os.environ['HOME'], 'bin')
#if not os.path.isdir(binDir):
#    print('mkdir %s' % binDir)
#    os.makedirs(binDir)
#
## --- make an undo dir
#undo_dir = os.path.join(os.environ['HOME'], '.undodir')
#if not os.path.isdir(undo_dir):
#    print('mkdir %s' % undo_dir)
#    os.makedirs(undo_dir)
#
## --- create a list of executable files to link
#execFileList = [
#    'git_diff_wrapper',
#    'git_branch_diff',
#    'circle_checker',
#    'serve_dir.py',
#    'imgcat',
#    'make_tags',
#    'clean_vim_backup.py',
#    'diffconflicts',
#    'myip',
#]
#
## --- link all exec files to $HOME/bin
#for execFile in execFileList:
#    cmd = "cd ~/bin; ln -sf ~/dot_files/{} .".format(execFile)
#    print(cmd)
#    os.system(cmd)
#
## --- if a home/.config directory doesnt exist, create it
#binDir = os.path.join(os.environ['HOME'], '.config')
#if not os.path.isdir(binDir):
#    print('mkdir %s' % binDir)
#    os.makedirs(binDir)
#
## --- link the git flake8 config file
#cmd = "cd ~/.config; ln -sf ~/dot_files/flake8 ."
#print(cmd)
#os.system(cmd)
#
## --- create a bash_history file if it doesn't exist
#if not os.path.isfile(os.path.join(os.environ['HOME'], '.bash_history')):
#    cmd = 'cp fake_bash_history {}/.bash_history'.format(os.environ['HOME'])
#    print(cmd)
#    os.system(cmd)
