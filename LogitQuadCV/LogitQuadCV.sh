#!/bin/bash
export OMP_NUM_THREADS=$NSLOTS
R CMD BATCH --no-save LogitQuadCV.R LogitQuadCV.out
# Now standardize

