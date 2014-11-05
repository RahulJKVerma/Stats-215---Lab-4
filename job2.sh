#!/bin/bash
export OMP_NUM_THREADS=$NSLOTS
R CMD BATCH --no-save SVM_Rahul.R SVM_Rahul2.Rout
# Gamma = 0.1
