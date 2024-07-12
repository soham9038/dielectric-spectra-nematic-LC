## Code to calculate angle between two frames of a unit vector ##
## python3 code.py ##

import numpy as np

def read_data(file_path):
    with open(file_path, 'r') as file:
        data = [line.strip().split() for line in file.readlines()]
    vectors = [(float(x), float(y)) for x, y in data]
    return vectors

def calculate_angles(vectors):
    angles = []
    for i in range(1, len(vectors)):
        u = np.array(vectors[i-1])
        v = np.array(vectors[i])
        dot_product = np.dot(u, v)
        angle = np.arccos(dot_product)
        angles.append(angle)
    return angles

def write_angles(file_path, angles):
    with open(file_path, 'w') as file:
        for angle in angles:
            file.write(f"{angle}\n")

# Read the vectors from the file
input_file = 'data.txt'
output_file = 'angles.txt'
vectors = read_data(input_file)

# Calculate the angles between consecutive vectors
angles = calculate_angles(vectors)

# Write the angles to the output file
write_angles(output_file, angles)

