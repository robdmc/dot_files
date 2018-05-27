#! /usr/bin/env bash
mkdir -p ~/bash_hooks && \
. ~/rcconda.sh && \
hash -r
conda env create --force -f ~/dot_files/environment.yml &&\
cp ~/dot_files/viz_init.sh ~/bash_hooks && \
~/dot_files/conda_condigure_holoviews.sh
