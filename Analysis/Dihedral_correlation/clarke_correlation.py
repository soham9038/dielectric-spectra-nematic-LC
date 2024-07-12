# Code to calculate correlation function according Equation 10
# python3 code.py

import numpy as np

# Load the dihedral angle data from the file
angles = np.loadtxt('data.txt')

# Function to classify angles into states
def classify_state(angle):
    if 0 < angle < 120:
        return 1  # Gauche+
    elif -120 < angle < 0:
        return 2  # Gauche-
    elif angle < -120 or angle > 120:
        return 3  # Trans
    else:
        return 0  # outside any defined state

# Classify all angles into states
states = np.array([classify_state(angle) for angle in angles])

# Function to calculate H_x(t)
def H_x_t(state, x):
    return np.where(state == x, 1, 0)

# Calculate H_x(t) for each state
H1 = H_x_t(states, 1)
H2 = H_x_t(states, 2)
H3 = H_x_t(states, 3)

# Function to calculate C_xy for a given lag
def C_xy(H_x, H_y, lag, is_self_correlation=False):
    # Ensure H_x and H_y are of the same length after shifting
    H_x_lagged = np.roll(H_x, lag)
    valid_range = len(H_x) - lag
    H_x_lagged = H_x_lagged[:valid_range]
    H_y = H_y[:valid_range]

    if is_self_correlation:
        mean_H_x = np.mean(H_x[:valid_range])
        mean_H_y = np.mean(H_y[:valid_range])
        num = np.mean((H_x_lagged - mean_H_x) * (H_y - mean_H_y))
        denom = np.std(H_x[:valid_range]) * np.std(H_y[:valid_range])
        return num / denom if denom != 0 else 0
    else:
        # For cross-correlation, normalize so that it starts from 0 and fluctuates around 1
        num = np.sum(H_x_lagged * H_y)
        denom = np.sqrt(np.sum(H_x_lagged * H_x_lagged) * np.sum(H_y * H_y))
        return num / denom if denom != 0 else 0

# Define the maximum lag
max_lag = 5000  # Adjust as needed

# Compute the autocorrelation and cross-correlation functions for each combination and lag
correlation_results = {}
for i, (Hx, Hy) in enumerate([(H1, H1), (H1, H2), (H1, H3), (H2, H1), (H2, H2), (H2, H3), (H3, H1), (H3, H2), (H3, H3)]):
    key = f"C{i//3+1}{i%3+1}"
    is_self_correlation = (i//3+1 == i%3+1)
    calculated_values = [C_xy(Hx, Hy, lag, is_self_correlation) for lag in range(max_lag + 1)]
    
    if not is_self_correlation:
        # Normalize the values by dividing by the average of the last 1000 values
        normalization_factor = np.mean(calculated_values[-1000:])
        final_values = calculated_values / normalization_factor
    else:
        final_values = calculated_values
    
    correlation_results[key] = final_values

# Write results to a text file in column format
with open('correlation_results.txt', 'w') as f:
    # Write the headers
    f.write("Lag")
    for key in correlation_results.keys():
        f.write(f"\t{key}")
    f.write("\n")
    
    # Write the values
    for lag in range(max_lag + 1):
        f.write(f"{lag}")
        for key in correlation_results.keys():
            f.write(f"\t{correlation_results[key][lag]:.6f}")
        f.write("\n")

