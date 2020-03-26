FILECONFIRMED = './COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv'
FILEDEATHS = './COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv'
FILERECOVERED = './COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv'
import csv
import pdb
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

def read_data_state(data_file,state,rowcut=1,colcut=4):
    data = np.array([])
    with open(data_file, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        i = 0
        for row in reader:
            i+=1
            if(state==row[0]):
                return np.array(list(map(int,row[colcut:])))[None,:]

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

def get_labelled_data_from_csv(data_file,rowcut=1,colcut=4): 
    lab_data = dict()
    with open(data_file, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        i = 0
        for row in reader:
            row = np.array(row)
            i += 1
            if(i <= rowcut):
                continue
            labelstr=row[1].replace(' ','_')
            row[row==''] = '0'
            arr = row[colcut:].astype(np.double)
            
            lab_data[labelstr] = arr + lab_data[labelstr] if labelstr in lab_data else arr
            if('Global' in lab_data):
                lab_data['Global'] += arr
            else:
                lab_data['Global'] = arr
    return lab_data


# Saves data in the form readable by the R script.  It should save ALL POSSIBLE PAIRS
def save_formatted_data(C,R,D, min_cases=1000):
    for r1 in C.keys():
        for r2 in C.keys():
            if (C[r1][-1] < min_cases) or (C[r2][-1] < min_cases):
                continue

            recd_daily1 = (to_daily(R[r1])*1.0)[:,None]
            dead_daily1 = (to_daily(D[r1])*1.0)[:,None]
            conf_daily1 = (to_daily(C[r1])*1.0)[:,None]
            
            recd_daily2 = (to_daily(R[r2])*1.0)[:,None]
            dead_daily2 = (to_daily(D[r2])*1.0)[:,None]
            conf_daily2 = (to_daily(C[r2])*1.0)[:,None]
            l = D[r1].shape[0]
            z = np.concatenate((np.arange(1,l)[:,None],1.0*np.ones((l-1,1)),recd_daily1,dead_daily1,conf_daily1),axis=1)
            z2 = np.concatenate((np.arange(1,l)[:,None],2.0*np.ones((l-1,1)),recd_daily2,dead_daily2,conf_daily2),axis=1)
            mat = np.concatenate((z,z2),axis=0)
            np.save('./numpy_data/' + r1 + '_' + r2 + '.npy',mat)

if __name__ == "__main__":
    # The rows are cities, the columns are time points.
    C = get_labelled_data_from_csv(FILECONFIRMED)
    R = get_labelled_data_from_csv(FILERECOVERED)
    D = get_labelled_data_from_csv(FILEDEATHS)
    CI = C['China']
    RI = R['China']
    DI = D['China']
    plot_estimator(naive_est(RI,DI,CI),fig="Estimators",label="naive estimate")
    plot_estimator(resolved_est(RI,DI,CI),fig="Estimators",label="observed estimate")
    plot_estimator(lagged_est(RI,DI,CI),fig="Estimators",label="5-day lagged estimate")
    #plt.show()
    save_formatted_data(C,R,D)
