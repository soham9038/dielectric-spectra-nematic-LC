## Code to fit Cole-Cole plot to a semi-circular fit ##
## python3 code.py ##

import numpy as np
import scipy.optimize as opt
import matplotlib.pyplot as plt

# Step 1: Read the data from 'data.txt'
data = np.loadtxt('data.txt') # 'data.txt' contains two columns, real part in the x-axis, imaginay part in the y-axis
x = data[:, 0]
y = data[:, 1]

# Step 2: Define the circle equation to fit
def semicircle_fit(params, x, y):
    h, r, k = params
    return (x - h)**2 + (y - k)**2 - r**2

# Initial guess for the parameters (h, r, k)
initial_guess = [np.mean(x), np.max(y), 0]  # Assume k starts at 0

# Use least squares to fit the semicircle
result = opt.least_squares(semicircle_fit, initial_guess, args=(x, y))
h_fit, r_fit, k_fit = result.x

# Step 3: Write the fitted parameters to 'output.txt'
with open('output.txt', 'w') as f:
    f.write(f'h: {h_fit}\n')
    f.write(f'r: {r_fit}\n')
    f.write(f'k: {k_fit}\n')

