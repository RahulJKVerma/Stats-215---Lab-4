#!/bin/bash
export OMP_NUM_THREADS=$NSLOTS
R CMD BATCH --no-save SVM_Rahul.R SVM_Rahul5.Rout
# gamma = 0.01
# Full x's
