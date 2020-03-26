FILECONFIRMED = './COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv'
FILEDEATHS = './COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv'
FILERECOVERED = './COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv'
import csv
import pdb
import numpy as np
#import seaborn as sns
import matplotlib.pyplot as plt

# Reads in a csv file from the coronavirus dataset. Cuts the first rowcut rows and colcut columns off.
def read_data(data_file,rowcut=1,colcut=4):
    data = np.array([])
    with open(data_file, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        i = 0
        for row in reader:
            row = np.array(row)
            i += 1
            if(i <= rowcut):
                continue
            # For fixing an error in their code...
            row[row==''] = '0'
            arr = row[colcut:][None,:].astype(np.double)
            if(i == 2):
                data = arr
            else:
                data = np.append(data,arr,axis=0)
    return data

# takes in a list of curves
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
            c = c #np.log10(c)
        plt.semilogy(c, label=labels[i])
        #sns.lineplot(hue=colors[i],data=c,label=labels[i])
    plt.xlabel("time (days elapsed)")
    plt.ylabel("number of individuals")
    plt.legend()
    
def to_daily(data):
    return np.diff(data)

def naive_est(recd,dead,conf):
    return dead/conf

def resolved_est(recd,dead,conf):
    return dead/(recd+dead)

def plot_estimator(estimate, fig=None,label=None):
    if(fig != None):
        plt.figure(fig)
    plt.plot(estimate, label=label)
    #sns.lineplot(data=estimate,label=label)
    plt.xlabel("time (days elapsed)")
    plt.ylabel("Case Fatality Rate (CFR)")
    plt.legend()
    
if __name__ == "__main__":
    #sns.set_style("dark")
    # The rows are cities, the columns are time points.
    recd = read_data(FILERECOVERED)
    dead = read_data(FILEDEATHS)
    conf = read_data(FILECONFIRMED)
    reso = recd+dead
    recd = np.sum(recd,axis=0)
    dead = np.sum(dead,axis=0)
    conf = np.sum(conf,axis=0)
    reso = recd+dead
    print(dead[-1]/(dead[-1]+recd[-1]))
    plot_curves([recd,dead,conf,reso],labels=["total recoveries","total deaths","total cases","total recoveries and deaths"],fig="Raw Data")
    plot_estimator(naive_est(recd,dead,conf),fig="Estimators",label="naive estimate")
    plot_estimator(resolved_est(recd,dead,conf),fig="Estimators",label="observed estimate")
    recd_daily = (to_daily(recd)*1.0)[:,None]
    dead_daily = (to_daily(dead)*1.0)[:,None]
    conf_daily = (to_daily(conf)*1.0)[:,None]
    l = len(dead)
    print(f"Data points:{l}")
    z = np.concatenate((np.arange(1,l)[:,None],1.0*np.ones((l-1,1)),recd_daily,dead_daily,conf_daily),axis=1)
    z2 = np.concatenate((np.arange(1,l)[:,None],2.0*np.ones((l-1,1)),recd_daily,dead_daily,conf_daily),axis=1)
    mat = np.concatenate((z,z2),axis=0)
    np.save('./numpy_data/recovered.npy', recd_daily)
    np.save('./numpy_data/dead.npy', dead_daily)
    np.save('./numpy_data/cases.npy',conf_daily)
    np.save('./numpy_data/mat.npy',mat)
    #plt.show()
