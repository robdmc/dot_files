import os
import sys
import numpy as np
import pylab as pl
import pandas as pd
import matplotlib as mpl
import statsmodels.formula.api as sm
import seaborn as sns

sys.path.append('~/helpers')

sns.set_context('talk')
CC = mpl.rcParams['axes.color_cycle']

pd.set_option('display.max_rows',600)
pd.set_option('display.max_columns',300)
pd.set_option('mode.use_inf_as_null',True)

from IPython.core.display import HTML
from IPython.core.display import display
def print_html(df):
    if type(df) == str:
        display(HTML(df))
    else:
        display(HTML(df.to_html()))
