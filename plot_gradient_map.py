# -*- coding: utf-8 -*-
"""
Created on Mon Mar 30 22:43:42 2026

@author: windows-11
"""

# -*- coding: utf-8 -*-
"""
Created on Tue Feb  3 01:02:27 2026, red-blue only

@author: windows-11
"""

import nibabel as nib
import numpy as np
import pandas as pd
from nilearn import plotting
from matplotlib.colors import LinearSegmentedColormap, Normalize
import os

# === 1. Set file paths ===
mask_path = r"C:\toolbox\atlas\BG219~230\striatum_mask_with_labels_1_to_12.nii"  # Path to the striatum mask
excel_path = r"C:\toolbox\atlas\BG219~230\R_values.xlsx"  # Excel file containing R values
output_dir = os.path.dirname(excel_path)  # Output directory

# === 2. Load the ROI NIfTI image ===
img = nib.load(mask_path)
data = img.get_fdata()  # Get 3D image data
affine = img.affine  # Get affine matrix

# === 3. Load R values from the Excel file ===
df = pd.read_excel(excel_path)  # Read Excel data
r_values = df['R Value'].values  # Extract the "R Value" column

r_min, r_max = r_values.min(), r_values.max()  # Get the minimum and maximum R values

# Create a new 3D array for visualization
colored_data = np.zeros_like(data)

# Assign each R value to its corresponding ROI label (1 to 12)
for label in range(1, 13):  # Loop through labels 1 to 12
    colored_data[data == label] = r_values[label - 1]  # Assign the corresponding R value to each labeled region

# === 4. Create a custom blue-to-red colormap ===
colors = [(0, 'blue'), (1, 'red')]  # Define blue-to-red gradient
cmap_blue_to_red = LinearSegmentedColormap.from_list("blue_to_red", colors, N=256)

# === 5. Plot the glass brain ===
# Create a new NIfTI image
new_img = nib.Nifti1Image(colored_data, affine)

# Plot the glass brain
glass = plotting.plot_glass_brain(
    new_img,
    title="Striatum - 12 ROI Glass Brain",  # Figure title
    cmap=cmap_blue_to_red,  # Use the custom blue-to-red colormap
    threshold=0.0,  # Set threshold to 0 so that all regions are displayed
    colorbar=True,  # Show the colorbar
    vmax=r_max,  # Maximum value for color mapping
    vmin=r_min   # Minimum value for color mapping
)

# === 6. Save the figure ===
save_path = os.path.join(output_dir, 'striatum_12_roi_glass_blue_red.png')  # Output file path
glass.savefig(save_path, dpi=300)  # Save figure
glass.close()  # Close figure

print(f"✅ The 12-ROI striatum glass brain map has been generated and saved to: {save_path}")