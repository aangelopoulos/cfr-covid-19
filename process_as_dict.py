FILECONFIRMED = './COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
FILEDEATHS = './COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv'
FILERECOVERED = './COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv'

import csv
import pdb
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

# takes in a list of curves and labels and plots them
def plot_curves(curves,colors=None,labels=None,fig=None,log=True):
    if(labels==None):
        labels = [None]*len(curves)
    if(colors==None):
        colors = [None]*len(curves)
    if(fig != None):
        plt.figure(fig)
    for i in range(len(curves)):
        c = curves[i]
        if(log):
            c = np.log10(c)
        sns.lineplot(hue=colors[i],data=c,label=labels[i])
    plt.xlabel("time (days)")
    plt.ylabel("#")

def to_daily(data):
    return np.diff(data)

def naive_est(recd,dead,conf):
    idx = np.where(conf>20)
    conf[conf==0]=1
    return dead[idx]/conf[idx]

def resolved_est(recd,dead,conf):
    O = recd+dead
    idx = np.where(conf>20)
    O[O==0]=1
    return dead[idx]/O[idx]

def lagged_est(recd,dead,conf,T=5):
    idx = np.where(conf>20)
    conf[conf==0]=1
    dead = dead[idx]
    conf = conf[idx]
    dead = dead[T:]
    conf = conf[:-T]
    est = dead/conf
    return np.insert(est,0,np.zeros((T,)))

def plot_estimator(estimate, fig=None,label=None):
    if(fig != None):
        plt.figure(fig)
    sns.lineplot(data=estimate,label=label)
    plt.xlabel("time (days)")
    plt.ylabel("CFR")

def csv2dict(data_file,colcut=4): 
    lab_data = dict() # This will be a dictionary of dictionaries.
    # The first level is by country. The second level is by state.
    # If there are no states within the country, the second level 
    # will just be the country name again.
    with open(data_file, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        i = 0
        for row in reader:
            row = np.array(row)
            i += 1
            if(i == 1):
                lab_data['Dates'] = row[colcut:]
                continue
            country_str=row[1]
            state_str = row[0]
            if(state_str == ''):
                state_str = country_str
            row[row==''] = '0' #Sometimes the csv has errors
            arr = row[colcut:].astype(np.double) # Cut off the strings at the beginning.
            # Populate the arrays.
            if country_str not in lab_data:
                lab_data[country_str] = dict()
            lab_data[country_str][state_str]=arr
    return lab_data

if __name__ == "__main__":
    # The rows are cities, the columns are time points.
    C = csv2dict(FILECONFIRMED)
    R = csv2dict(FILERECOVERED)
    D = csv2dict(FILEDEATHS)
    pdb.set_trace()
