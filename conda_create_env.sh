#! /usr/bin/env bash
. ~/rcconda.sh
conda env create --force -f ~/dot_files/environment.yml &&\
~/dot_files/conda_condigure_holoviews.sh
