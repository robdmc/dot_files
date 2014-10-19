#! /usr/bin/env python

import os

# --- create a list of files that should just be directly linked to home
linkFileList = [
               '.bash_profile',
               '.bashrc',
               '.inputrc',
               '.vim',
               '.vimrc',
               '.ackrc',
               '.mongorc.js',
               '.zshenv',
               '.zshrc',
               '.ctags',
               'pandasSetup.py',
               'rcconda.sh',
               ]

# --- link the files to home
for linkFile in linkFileList:
    cmd = "cd ~; ln -sf ./setupFiles/%s ." % linkFile
    print cmd
    os.system(cmd)

# --- link the .gitconfig file
cmd = "cd ~; ln -sf ./setupFiles/gitconfig .gitconfig"
print cmd
os.system(cmd)

# --- link the .gitignore file
cmd = "cd ~; ln -sf ./setupFiles/gitignore_global .gitignore_global"
print cmd
os.system(cmd)


# --- if a home/bin directory doesnt exist, create it
binDir = os.path.join(os.environ['HOME'],'bin')
if not os.path.isdir(binDir):
    print 'mkdir %s' % binDir
    os.makedirs(binDir)

# --- link executables
cmd = "cd ~/bin; ln -sf ~/setupFiles/git_diff_wrapper ."
print cmd
os.system(cmd)

cmd = "cd ~/bin; ln -sf ~/setupFiles/git_branch_diff ."
print cmd
os.system(cmd)

# --- if a home/.config directory doesnt exist, create it
binDir = os.path.join(os.environ['HOME'],'.config')
if not os.path.isdir(binDir):
    print 'mkdir %s' % binDir
    os.makedirs(binDir)

# --- link the git flake8 config file
cmd = "cd ~/.config; ln -sf ~/setupFiles/flake8 ."
print cmd
os.system(cmd)

