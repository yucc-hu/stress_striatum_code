#!/bin/bash
# =============================================================
# fMRIPrep preprocessing
# =============================================================
# Usage:
#   bash run_fmriprep.sh
#
# Before running, set the three paths below to match
# your local directory structure.
# =============================================================

# ---- Set your paths here ------------------------------------
BIDS_DIR=/path/to/bids_data
OUTPUT_DIR=/path/to/output
FREESURFER_LICENSE=/path/to/license.txt
# -------------------------------------------------------------

docker run --rm -ti --gpus all \
    -v ${BIDS_DIR}:/data:ro \
    -v ${OUTPUT_DIR}:/out \
    -v ${FREESURFER_LICENSE}:/opt/freesurfer/license.txt:ro \
    nipreps/fmriprep:VERSION_NUMBER \
    /data /out participant \
    --fs-no-reconall \
    --output-spaces MNI152NLin2009cAsym T1w \
    --write-graph
