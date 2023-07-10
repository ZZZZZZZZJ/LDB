DECOLOR -- updated on May 25, 2016.
This package implements the DECOLOR algorithm proposed in the following manuscript:
http://arxiv.org/PS_cache/arxiv/pdf/1109/1109.0882v1.pdf

1. This package of codes has been tested on Windows 7 64-bit, with Matlab version R2015a
2. gco-v3.0 is needed and has been included in the package.
3. Folder 'data' includes the sequences, which are stored in .mat files.
   Each sequence is a 3D matrix named 'ImData' storing a sequence of gray-scale images.
4. DECOLOR detects contiguous outliers in a 2D matrix
   PCP is for comparison
   ObjDetection_DECOLOR uses DECOLOR to detect moving objects.
   RUN_SIMU demonstrates the simulation.
   RUN_REAL_STATIC demonstrates the experiments on seuqences with static cameras.
   RUN_REAL_MOVING demonstrates the experiments on seuqences with moving cameras.
5. Any questions are welcomed. Please contact: xiaowz@seas.upenn.edu




