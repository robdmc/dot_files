import os
import sys
import numpy as np
import pylab as pl
import pandas as pd
import matplotlib as mpl
import statsmodels.formula.api as sm
#import pymc

pd.set_option('display.max_rows',600)
pd.set_option('display.max_columns',300)
pd.set_option('display.height',600)
pd.set_option('display.width',1800)
pd.set_option('mode.use_inf_as_null',True)

from IPython.core.display import HTML
from IPython.core.display import display
def print_html(df):
    if type(df) == str:
        display(HTML(df))
    else:
        display(HTML(df.to_html()))

#=============================================================================
def rc(theme='gray'):
    """
    Sets themes for plots.  The allowed themes are
    'gray (or grey)', 'mpl', 'slideFull', 'slideHalf', 'slideBumper',
    'slideHalfBumper', 'landscape', 'portrait'
    """

    #--- initialize a dict to hold all themes
    themeDict = {}

    #--- set the default params (good for ipython)
    rcd = {
            'figure.figsize': '6, 4',
            "figure.figsize": "11, 8",
            'figure.facecolor': 'white',
            'figure.edgecolor': 'white',
            'font.size': '10',
            'savefig.dpi': 72,
            'figure.subplot.bottom' : .125
            }
    themeDict['mpl'] = rcd

    #--- set stuff for slideFull
    rcd = dict(themeDict['mpl'])
    rcd['font.weight'] = 300  # (val = 100 to 900)
    rcd['font.size'] = 14  # (val = 100 to 900)
    rcd['axes.titlesize'] = 18
    rcd['axes.labelsize'] = 16
    rcd['axes.linewidth'] = 2
    rcd["xtick.major.size"] = 7
    rcd["ytick.major.size"] = 7
    rcd['xtick.major.pad'] = 6
    rcd['ytick.major.pad'] = 6
    rcd['lines.linewidth'] = 2
    rcd['lines.markersize'] = 7
    rcd["figure.figsize"] = [8.8, 5.9]
    rcd['savefig.dpi'] = 300
    themeDict['slideFull'] = rcd

    #--- set stuff for slide half
    rcd = dict(themeDict['slideFull'])
    rcd["figure.figsize"] = [4.8, 5.7]
    themeDict['slideHalf'] = rcd

    #--- set stuff for slide bumber
    rcd = dict(themeDict['slideFull'])
    rcd["figure.figsize"] = [8.8, 4.9]
    themeDict['slideBumper'] = rcd

    #--- set stuff for slide half bumber
    rcd = dict(themeDict['slideFull'])
    rcd["figure.figsize"] = [4.8, 4.9]
    themeDict['slideHalfBumper'] = rcd

    #--- set stuff for slide portrait
    rcd = dict(themeDict['slideFull'])
    rcd["figure.figsize"] = [8.5, 11]
    themeDict['portrait'] = rcd

    #--- set stuff for slide landscape
    rcd = dict(themeDict['slideFull'])
    rcd["figure.figsize"] = [11, 8.5]
    themeDict['landscape'] = rcd

    #--- define the slightly modified ggplot theme
    rcd = {}
    rcd["timezone"] = "UTC"
    rcd["lines.linewidth"] = "1.0"
    rcd["lines.antialiased"] = "True"
    rcd["patch.linewidth"] = "0.5"
    rcd["patch.facecolor"] = "348ABD"
    rcd["patch.edgecolor"] = "#E5E5E5"
    rcd["patch.antialiased"] = "True"
    rcd["font.family"] = "sans-serif"
    rcd["font.size"] = "12.0"
    rcd["font.serif"] = ["Times", "Palatino", "New Century Schoolbook",
                                 "Bookman", "Computer Modern Roman",
                                 "Times New Roman"]
    rcd["font.sans-serif"] = ["Helvetica", "Avant Garde",
                                      "Computer Modern Sans serif", "Arial"]
    rcd["axes.facecolor"] = "#E5E5E5"
    rcd["axes.edgecolor"] = "bcbcbc"
    rcd["axes.linewidth"] = "1"
    rcd["axes.grid"] = "True"
    rcd["axes.titlesize"] = "x-large"
    rcd["axes.labelsize"] = "large"
    rcd["axes.labelcolor"] = "black"
    rcd["axes.axisbelow"] = "True"
    rcd["axes.color_cycle"] = [
            "348ABD",
            "A60628",
            "467821",
            "#333333",
            "7A68A6",
            "CF4457",
            "188487",
            "E24A33"
            ]
    #rcd["axes.color_cycle"] = [ these are colorbrewar-12 category colors
    #        '#a6cee3',
    #        '#1f78b4',
    #        '#b2df8a',
    #        '#33a02c',
    #        '#fb9a99',
    #        '#e31a1c',
    #        '#fdbf6f',
    #        '#ff7f00',
    #        '#cab2d6',
    #        '#6a3d9a',
    #        '#ffff99',
    #        '#b15928',
    #        "#333333"
    #        ]
    rcd["grid.color"] = "white"
    rcd["grid.linewidth"] = "1.4"
    rcd["grid.linestyle"] = "solid"
    rcd["xtick.major.size"] = "0"
    rcd["xtick.minor.size"] = "0"
    rcd["xtick.major.pad"] = "6"
    rcd["xtick.minor.pad"] = "6"
    rcd["xtick.color"] = "#7F7F7F"
    rcd["xtick.direction"] = "out"  # pointing out of axis
    rcd["ytick.major.size"] = "0"
    rcd["ytick.minor.size"] = "0"
    rcd["ytick.major.pad"] = "6"
    rcd["ytick.minor.pad"] = "6"
    rcd["ytick.color"] = "#7F7F7F"
    rcd["ytick.direction"] = "out"  # pointing out of axis
    rcd["legend.fancybox"] = "True"
    rcd["figure.figsize"] = "11, 8"
    rcd["figure.facecolor"] = "1.0"
    rcd["figure.edgecolor"] = "0.50"
    rcd["figure.subplot.hspace"] = "0.5"
    rcd['savefig.dpi'] =  72
    themeDict['gray'] = rcd
    themeDict['grey'] = rcd

    #--- set the default params if requested
    if theme in ['mpl', 'slideFull', 'slideHalf', 'slideBumper', 
            'portrait', 'landscape']:
        mpl.rcdefaults()

    #--- set the params
    for k, v in themeDict[theme].iteritems():
        if v:
            mpl.rcParams[k] = v
