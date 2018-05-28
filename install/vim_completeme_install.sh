#! /usr/bin/env bash

brew install cmake || true
rm -rf ~/.vim/bundle/YouCompleteMe 2>/dev/null || true
cd ~/.vim/bundle && \
git clone https://github.com/Valloric/YouCompleteMe.git && \
cd YouCompleteMe && \
git submodule update --init --recursive && \
python install.py




