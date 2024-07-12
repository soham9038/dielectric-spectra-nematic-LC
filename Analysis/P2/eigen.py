import numpy as np
from numpy.linalg import eig

File = np.loadtxt('matrix.txt')
a=np.array(File)
w,v=eig(a)
print(w)
print(v)
