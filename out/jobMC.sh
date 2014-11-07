#!/bin/bash
export OMP_NUM_THREADS=$NSLOTS
R CMD BATCH --no-save LinearModelMC.R LinearModelMC.Rout

