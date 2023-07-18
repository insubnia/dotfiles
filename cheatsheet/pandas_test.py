#!/usr/bin/python3
import numpy as np
import pandas as pd


def pos_by_val(df, val):
    rows, cols = np.where(df==val)
    return [(r, c) for r,c in zip(rows, cols)]


def trim_df(df, corner_val):
    df = df.dropna(how='all')
    r_start, c_start = pos_by_val(df, corner_val)[0]
    df = df.iloc[r_start:, c_start:]
    df.index = range(len(df.index))
    df.columns = [''] * len(df.columns)
    return df


if __name__ == "__main__":
    df = pd.read_excel(io='./Barcelona_DIG_Registers_MCUP_Map_v0.xlsx',
                       sheet_name='I2C Controller')
    df = trim_df(df, corner_val='Addr')
