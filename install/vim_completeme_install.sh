#! /usr/bin/env bash

brew install cmake && \
rm -rf ~/dot_files/.vim/bundle/YouCompleteMe 2>/dev/null || true
cd ~/dot_files/.vim/bundle && \
git clone https://github.com/Valloric/YouCompleteMe.git && \
cd YouCompleteMe && \
git submodule update --init --recursive && \
python install.py




