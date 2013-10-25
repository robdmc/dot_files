import os
import sys
import numpy as np
import pylab as pl
import pandas as pd
import matplotlib
import statsmodels.api as sm
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

