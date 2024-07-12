# Code to calculate correlation function according Equation 11
# python3 code.py

import numpy as np

def calculate_autocorrelation(data):
    # Number of data points
    N = len(data) # angle needs to be in radian
    
    # Compute mean and variance of the cosine of dihedral angles
    cos_data = np.cos(data)
    mean_cos = np.mean(cos_data)
    var_cos = np.var(cos_data)
    
    # Autocorrelation function
    autocorr = np.zeros(N)
    
    for t in range(N):
        # Compute the autocorrelation for lag t
        if t == 0:
            autocorr[t] = 1.0  # Normalization for lag 0
        else:
            autocorr[t] = (np.mean(cos_data[:N-t] * cos_data[t:]) - mean_cos**2) / var_cos
    
    return autocorr

# Read the data from 'data.txt'
data = np.loadtxt('data.txt')

# Calculate the autocorrelation function
autocorr = calculate_autocorrelation(data)

# Write the autocorrelation function to 'autocorrelation.txt'
np.savetxt('autocorrelation.txt', autocorr)

print("Autocorrelation function calculation complete. Output written to 'autocorrelation.txt'.")

