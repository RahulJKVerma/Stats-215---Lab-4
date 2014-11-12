#!/bin/bash
export OMP_NUM_THREADS=$NSLOTS
R CMD BATCH --no-save RFConvergence.R RFConvergence.out

