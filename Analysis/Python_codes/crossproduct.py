## Code to calculate cross product of two unitvectors ##
## python3 code.py ##

import numpy as np

# Define the input file names
file1 = "f1.txt" # first vector
file2 = "f2.txt" # Second vector

# Define the output file name
output_file = "cross_product_output.txt"

# Load data from the input files
data1 = np.loadtxt(file1)
data2 = np.loadtxt(file2)

# Check if the dimensions of the two input files match
if data1.shape != data2.shape:
    print("Error: Input file dimensions do not match.")
else:
    # Calculate the cross product for each row
    cross_products = np.cross(data1, data2, axis=1)

    # Write the cross products to the output file
    np.savetxt(output_file, cross_products, fmt="%.6f", delimiter="\t")

    print(f"Cross products written to {output_file}")
