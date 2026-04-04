# fMRIPrep Preprocessing

Preprocessing code associated with:

> Manuscript under review.

---

## Software

| Software | Version |
|----------|---------|
| fMRIPrep | 25.1.4  |
| Docker   | —       |

A FreeSurfer license is required.
Free registration at: https://surfer.nmr.mgh.harvard.edu/registration.html

---

## Usage

1. Edit the three paths at the top of `run_fmriprep.sh`
2. Run:

```bash
bash run_fmriprep.sh
```

---

## Input

Input data must follow [BIDS format](https://bids.neuroimaging.io/).

---

## Output

fMRIPrep outputs preprocessed images and confound files
(framewise displacement, DVARS, etc.) to `OUTPUT_DIR`.
Subsequent denoising was performed separately (see paper Methods).

---

## Contact

For questions about the code: 1456734610@qq.com

For questions about the paper: Juan Yang (valleyqq@swu.edu.cn)
