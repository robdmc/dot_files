from IPython.core.display import HTML
from IPython.core.display import display

try:
    import pandas as pd
    pd.set_option('display.max_rows', 600)
    pd.set_option('display.max_columns', 300)
    pd.set_option('mode.use_inf_as_null', True)
    pd.set_option('display.max_colwidth', 200)
except:
    pass


def print_html(df):
    if type(df) == str:
        display(HTML(df))
    else:
        display(HTML(df.to_html()))
