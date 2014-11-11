#!/bin/bash
# export OMP_NUM_THREADS=$NSLOTS
R CMD BATCH --no-save LogisticModel.R LogisticModel.out

