# -*- coding: utf-8 -*-
"""


@author:Deepika Gupta
"""



# This is code for predicting feature from DNN model 
# Change this your requirement


import pandas as pd
import numpy as np
import matplotlib as plt
from scipy.io import loadmat
from keras import regularizers
from keras.models import Sequential

np.random.seed(7)
# read features from .dat file
data= pd.read_csv('input.mat',header=None)
X = data.iloc[:,0:63]
del  data

from keras.models import load_model
model = load_model('my_model.h5')  # creates a HDF5 file 'my_model.h5'

y_predicted=model.predict(X,batch_size=128)
del model
del X 
import scipy.io as sio
yy = [ np.array([y_predicted])];
obj_arr = np.zeros((1,), dtype=np.object)
obj_arr[0] = yy[0]
# save predicted info in .mat format
sio.savemat('features_K.mat', mdict={'yy':obj_arr})

