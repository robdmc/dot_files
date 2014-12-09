import contextlib
import datetime as datetime_module
import os
import sys

import matplotlib as mpl
import numpy as np
import pandas as pd
import pylab as pl
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.formula.api as sm

home = os.environ['HOME']
helper_path = os.path.join(home, 'helpers')
if helper_path not in sys.path:
    sys.path.append(os.path.join(home, 'helpers'))

sns.set_context('talk')
CC = mpl.rcParams['axes.color_cycle']

pd.set_option('display.max_rows', 600)
pd.set_option('display.max_columns', 300)
pd.set_option('mode.use_inf_as_null', True)

from IPython.core.display import HTML
from IPython.core.display import display


def print_html(df):
    if type(df) == str:
        display(HTML(df))
    else:
        display(HTML(df.to_html()))

@contextlib.contextmanager
def Timer(name=''):
    """
    A context manager for timing sections of code

    Usage:

    with Timer('git er done'):
        for x in range(10):
            run_my_func(x)
    """
    tstart = datetime_module.datetime.now()
    yield
    if name:
        print '[%s]' % name,
    print 'Time: %s' % (datetime_module.datetime.now() - tstart)
