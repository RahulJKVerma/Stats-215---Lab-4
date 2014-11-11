#!/bin/bash
export OMP_NUM_THREADS=$NSLOTS
R CMD BATCH --no-save RandomForest.R RandomForest161-200.out

