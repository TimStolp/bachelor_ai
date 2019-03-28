# read_xlsx.py
#
# Reads the .xlsx files and turns them into useable pandas dataframes.
#

import pandas as pd


def read_xlsx(filename):
    """
    Reads a .xlsx file containing board and netlist data.
    Returns the name of the board, the dimensions of the board,
    a pandas dataframe containing gate coordinates, and a list of pandas dataframes containing netlists.
    """
    df = pd.read_excel(filename, index_col=None, header=None)
    name = df.ix[0, 1]
    dimensions = tuple([int(x) for x in df.ix[1, 1].split(" x ")])
    partitions = df[3:][0].isnull().cumsum()
    dflist = []
    for i in range(partitions.max()+1):

        if i > 0:
            temp_frame = df[3:][partitions == i].iloc[2:, :-1]
        else:
            temp_frame = df[3:][partitions == i]

        temp_frame.columns = temp_frame.iloc[0]
        temp_frame = temp_frame[1:]
        dflist.append(temp_frame)
    return name, dimensions, dflist[0], dflist[1:]
