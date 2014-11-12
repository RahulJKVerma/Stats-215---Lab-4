#!/bin/bash
export OMP_NUM_THREADS=$NSLOTS
R CMD BATCH --no-save LogitPolyCV.R LogitPolyCV2.out

