#! /usr/bin/env bash

# Sometimes osx doesn't do the right thing with certificates
# This fixes it
# pip3 install certifi || true

# Make sure env dir exists
mkdir -p ~/envs

# Blow out any existing env
rm -rf ~/envs/base/ 2>/dev/null || true

# Create the env and install dependencies
python3 -m venv ~/envs/base && \
. ~/envs/base/bin/activate && \
pip install -U pip &&\
pip install numpy &&\
pip install -r ~/dot_files/requirements.txt

# Make holovies play nicely with jupyterlab
hash -r
~/dot_files/conda_condigure_holoviews.sh
