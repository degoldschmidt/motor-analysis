'''This code shows how to import .mat file (MATLAB format) into dictionary using scipy.io'''

# First we will import the scipy.io
import numpy as np
import scipy.io as spio
import matplotlib.pyplot as plt
x = spio.loadmat('./test/v1_AndreMa_0.mat')
# easymatfile.mat contains 3 matlab variables
# a: [10x30]
# b: [20x100]
# c: [1x1]

# in order to get a, b and c we say
Baseline = x['Train']
Condition = x['Test']
After = x['After']

TrialXY = Baseline[0,0]['TrialDataXYAfter']
#print(TrialXY)
#firsttrial = TrialXY[1,0]



# Now we want plot the figures
#from pylab import *
#from matplotlib import *
#plot(firsttrial[:,0],firsttrial[:,1])
#matshow(pyB,2)
#matshow(pyC,3)

# Now, we will show all three figures
#show()