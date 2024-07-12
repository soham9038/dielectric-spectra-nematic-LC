## Code to calculate fit relaxation curve with Bi-exponential decay form ##
## python3 code.py ##

import numpy as np
from scipy.optimize import curve_fit

# Define the function to be fitted
def func(x, a, tau1, tau2):
    return a*np.exp(-x/tau1) + (1-a)*np.exp(-x/tau2)

# Read in the data from a text file
data = np.loadtxt('data.txt') # 'data.txt' contains two columns, first column- time, second column- normalized acf
x_data = data[:, 0]
y_data = data[:, 1]

# Use curve_fit to find the optimal values of a, tau1, and tau2
initial_guess = [0.5, 0.05, 0.25] # initial guess for a, tau1, and tau2
popt, pcov = curve_fit(func, x_data, y_data, p0=initial_guess)

# Write the results to a separate text file
with open('results.txt', 'w') as f:
    f.write(f"a = {popt[0]}\n")
    f.write(f"tau1 = {popt[1]}\n")
    f.write(f"tau2 = {popt[2]}\n")
