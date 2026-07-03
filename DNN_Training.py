# -*- coding: utf-8 -*-
"""
Created on Fri Jul  3 17:11:53 2026

@author: Alok Mittal
"""

# -*- coding: utf-8 -*-
"""


@author: Deepika Gupta


"""

# This is code for train DNN.
#Change according requirements

import pandas as pd
import numpy as np
import matplotlib as plt
from scipy.io import loadmat
from keras import regularizers
from keras.models import Sequential
from keras.layers import Dense , Dropout, Activation, BatchNormalization
from keras import optimizers
#from keras.optimizers import Adamax

np.random.seed(7)
data_train= pd.read_csv('file_training_input_output_features from .dat file',header=None) 
data_valid=pd.read_csv('file_validation_input_output_features from .dat file',header=None) 
X = data_train[:,0:63]
Y = data_train[:,63:]

X_valid=data_valid[:,0:63]
Y_valid=data_valid[:,63:]



model = Sequential()
model.add(Dense(128, input_dim=63))
model.add(BatchNormalization())
model.add(Activation('relu'))


model.add(Dense(128))
model.add(BatchNormalization())
model.add(Activation('relu'))


es = EarlyStopping(monitor='val_acc', mode='max',verbose=1,patience = patience)
mc= ModelCheckpoint(model_name, monitor='val_acc',mode='max',verbose=1,save_best_only=True)

model.add(Dense(15, activation='linear',kernel_regularizer=regularizers.l2(0.001)))
admax=   optimizers.Adamax(lr=0.01, beta_1=0.9, beta_2=0.999, epsilon=None, decay=1e-4)


model.compile(optimizer=admax, loss='mean_squared_error', metrics=['accuracy'])

history = model.fit(X, Y, epochs=50, batch_size=256,validation_split=0.0, validation_data=(X_valid,Y_valid),shuffle=True,,callbacks=[es, mc])

 # summarize history for accuracy
    plt.figure()
    plt.plot(history.history['acc'])
    plt.plot(history.history['val_acc'])
    plt.title('model accuracy')
    plt.ylabel('accuracy')
    plt.xlabel('epoch')
    plt.legend(['train', 'test'], loc='upper left')
 
    # summarize history for loss
    plt.figure()
    plt.plot(history.history['loss'])
    plt.plot(history.history['val_loss'])
    plt.title('model loss')
    plt.ylabel('loss')
    plt.xlabel('epoch')
    plt.legend(['train', 'test'], loc='upper left')
  

model.save('my_model.h5')  # creates a HDF5 file 'my_model.h5'


