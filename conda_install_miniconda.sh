#! /usr/bin/env bash

# mkdir -p ~/miniconda

if [ "$OS_TYPE" == "mac" ]; then 
    wget http://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p "$HOME/miniconda" && \
    rm /tmp/miniconda.sh
fi

if [ "$OS_TYPE" == "linux" ]; then 
    wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p "$HOME/miniconda" && \
    rm /tmp/miniconda.sh
fi
