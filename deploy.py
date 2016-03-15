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
    '.ctags',
    'pandasSetup.py',
    'rcconda.sh',
    'rcdocker.sh',
    'rcminiconda.sh',
]

# --- link the files to home
for linkFile in linkFileList:
    cmd = "cd ~; ln -sf ./dot_files/%s ." % linkFile
    print cmd
    os.system(cmd)

# --- link the .gitconfig file
cmd = "cd ~; ln -sf ./dot_files/gitconfig .gitconfig"
print cmd
os.system(cmd)

# --- link the .gitignore file
cmd = "cd ~; ln -sf ./dot_files/gitignore_global .gitignore_global"
print cmd
os.system(cmd)


# --- if a home/bin directory doesnt exist, create it
binDir = os.path.join(os.environ['HOME'],'bin')
if not os.path.isdir(binDir):
    print 'mkdir %s' % binDir
    os.makedirs(binDir)

# --- make an undo dir
undo_dir = os.path.join(os.environ['HOME'],'.undodir')
if not os.path.isdir(undo_dir):
    print 'mkdir %s' % undo_dir
    os.makedirs(undo_dir)

# --- link executables
cmd = "cd ~/bin; ln -sf ~/dot_files/git_diff_wrapper ."
print cmd
os.system(cmd)

cmd = "cd ~/bin; ln -sf ~/dot_files/git_branch_diff ."
print cmd
os.system(cmd)

cmd = "cd ~/bin; ln -sf ~/dot_files/circle_checker ."
print cmd
os.system(cmd)


# --- if a home/.config directory doesnt exist, create it
binDir = os.path.join(os.environ['HOME'],'.config')
if not os.path.isdir(binDir):
    print 'mkdir %s' % binDir
    os.makedirs(binDir)

# --- link the git flake8 config file
cmd = "cd ~/.config; ln -sf ~/dot_files/flake8 ."
print cmd
os.system(cmd)

