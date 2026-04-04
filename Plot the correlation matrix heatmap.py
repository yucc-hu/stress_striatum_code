# -*- coding: utf-8 -*-
"""
Created on Mon Mar 30 18:36:33 2026

@author: windows-11
"""

import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from PIL import Image

# =========================
# 1. File paths
# =========================
file_path = r"C:\Users\windows-11\Desktop\reward新endnote\FORmap\all\otherloss.xlsx"
temp_png_path = r"C:\Users\windows-11\Desktop\reward新endnote\FORmap\all\otherloss_heatmap_temp.png"
output_bmp_path = r"C:\Users\windows-11\Desktop\reward新endnote\FORmap\all\otherloss_heatmap_seismic.bmp"

# =========================
# 2. Adjustable parameters
# =========================
FIG_WIDTH = 16               # Figure width
FIG_HEIGHT = 9               # Figure height
CELL_ASPECT = 0.6            # Cell aspect ratio: <1 makes cells wider, >1 makes them taller
GRID_LINEWIDTH = 1.2         # Line width of each cell border
OUTER_BORDER_WIDTH = 2.0     # Line width of the outer border

LABEL_FONT_SIZE = 14         # Font size for variable names
LABEL_FONT_WEIGHT = "bold"   # Options: "normal" or "bold"

ANNOT_FONT_SIZE = 12         # Font size for significance stars
ANNOT_FONT_WEIGHT = "bold"   # Options: "normal" or "bold"

XTICK_ROTATION = 45          # Rotation angle of x-axis labels
TITLE = "Correlation Matrix Heatmap"
TITLE_FONT_SIZE = 16
SHOW_TITLE = True

SHOW_COLORBAR = True         # Whether to show the colorbar
CBAR_LABEL = "Correlation (r)"
CBAR_LABEL_SIZE = 12
CBAR_TICK_SIZE = 10

DPI = 300

# =========================
# 3. Read Excel file
#    Sheet 1 = p-values
#    Sheet 2 = r-values
# =========================
p_df = pd.read_excel(file_path, sheet_name=0, index_col=0)
r_df = pd.read_excel(file_path, sheet_name=1, index_col=0)

# =========================
# 4. Clean row and column names
# =========================
p_df.index = p_df.index.astype(str).str.strip()
p_df.columns = p_df.columns.astype(str).str.strip()

r_df.index = r_df.index.astype(str).str.strip()
r_df.columns = r_df.columns.astype(str).str.strip()

# =========================
# 5. Align the two matrices
# =========================
common_rows = r_df.index.intersection(p_df.index)
common_cols = r_df.columns.intersection(p_df.columns)

r_df = r_df.loc[common_rows, common_cols]
p_df = p_df.loc[common_rows, common_cols]

# Convert to numeric values
r_df = r_df.apply(pd.to_numeric, errors='coerce')
p_df = p_df.apply(pd.to_numeric, errors='coerce')

# =========================
# 6. Create annotation matrix
#    Only significance stars are shown
# =========================
annot = pd.DataFrame("", index=r_df.index, columns=r_df.columns)

for i in range(r_df.shape[0]):
    for j in range(r_df.shape[1]):
        r = r_df.iloc[i, j]
        p = p_df.iloc[i, j]

        if pd.isna(r) or pd.isna(p):
            annot.iloc[i, j] = ""
        else:
            if p < 0.001:
                annot.iloc[i, j] = "***"
            elif p < 0.01:
                annot.iloc[i, j] = "**"
            elif p < 0.05:
                annot.iloc[i, j] = "*"
            else:
                annot.iloc[i, j] = ""

# =========================
# 7. Font settings
# =========================
plt.rcParams['font.sans-serif'] = ['Arial', 'DejaVu Sans', 'Liberation Sans']
plt.rcParams['axes.unicode_minus'] = False

# =========================
# 8. Plot heatmap
# =========================
plt.figure(figsize=(FIG_WIDTH, FIG_HEIGHT))

ax = sns.heatmap(
    r_df,
    cmap="seismic",
    vmin=-1,
    vmax=1,
    center=0,
    annot=annot,
    fmt="",
    annot_kws={
        "size": ANNOT_FONT_SIZE,
        "weight": ANNOT_FONT_WEIGHT,
        "color": "black"
    },
    linewidths=GRID_LINEWIDTH,
    linecolor="black",
    square=False,
    cbar=SHOW_COLORBAR,
    cbar_kws={
        "shrink": 0.85,
        "label": CBAR_LABEL
    }
)

# Adjust cell shape: <1 makes cells wider
ax.set_aspect(CELL_ASPECT)

# Set axis label styles
ax.set_xticklabels(
    ax.get_xticklabels(),
    rotation=XTICK_ROTATION,
    ha='right',
    fontsize=LABEL_FONT_SIZE,
    fontweight=LABEL_FONT_WEIGHT
)

ax.set_yticklabels(
    ax.get_yticklabels(),
    rotation=0,
    fontsize=LABEL_FONT_SIZE,
    fontweight=LABEL_FONT_WEIGHT
)

# Remove tick marks
ax.tick_params(axis='both', length=0)

# Set colorbar font size
if SHOW_COLORBAR:
    cbar = ax.collections[0].colorbar
    cbar.ax.tick_params(labelsize=CBAR_TICK_SIZE)
    cbar.set_label(CBAR_LABEL, size=CBAR_LABEL_SIZE)

# Add outer black border
for spine in ax.spines.values():
    spine.set_visible(True)
    spine.set_linewidth(OUTER_BORDER_WIDTH)
    spine.set_color("black")

# Add title
if SHOW_TITLE:
    plt.title(TITLE, fontsize=TITLE_FONT_SIZE, pad=15, fontweight='bold')

plt.tight_layout()

# =========================
# 9. Save as PNG first, then convert to BMP
#    This is more stable for BMP export
# =========================
plt.savefig(temp_png_path, dpi=DPI, bbox_inches="tight", facecolor="white")
plt.close()

img = Image.open(temp_png_path)
img.save(output_bmp_path, format="BMP", dpi=(DPI, DPI))

# Remove temporary PNG file
if os.path.exists(temp_png_path):
    os.remove(temp_png_path)

print(f"BMP heatmap saved to: {output_bmp_path}")