#!/bin/bash
export OMP_NUM_THREADS=$NSLOTS
export DIR="~/Documents/Lab4Fixed/Stats-215---Lab-4/"
# Number of jobs for fast models: Linear, Logistic, QDA, LogitPoly
# A few seconds per job
export NJOBS_HIGH=200
# Number of jobs for medium models: naiveBayes, LogitPoly, RandomForest, NeuralNet
# A few minutes per job
export NJOBS_MED=50
# Number of jobs for SVM
# Painfully slow. 1 or 2 hour each. Set to 0 if you want to skip. 
export NJOBS_LOW=5

# You will see a file created in this folder e.g Done.LinearModel to notify 
# that the cluster finish running that model. At the end all Done.* file will be
# deleted. 

R CMD BATCH --no-save ./LinearModel/LinearModel.R     ./LinearModel/LinearModel.out
touch Done.LinearModel
R CMD BATCH --no-save ./LogisticModel/LogisticModel.R ./LogisticModel/LogisticModel.out
touch Done.LogisticModel
R CMD BATCH --no-save ./QDA/QDA.R                     ./QDA/QDA.out
touch Done.QDA
R CMD BATCH --no-save ./naiveBayes/naiveBayes.R       ./naiveBayes/naiveBayes.out
touch Done.naiveBayes
R CMD BATCH --no-save ./LogitPoly/LogitPoly.R         ./LogitPoly/LogitPoly.out
touch Done.LogitPoly
R CMD BATCH --no-save ./LogitCV/LogitCV.R             ./LogitCV/LogitCV.out
touch Done.LogitCV
R CMD BATCH --no-save ./NeuralNet/NeuralNet.R         ./NeuralNet/NeuralNet.out
touch Done.NeuralNet
R CMD BATCH --no-save ./RandomForest/RandomForest.R   ./RandomForest/RandomForest.out
touch Done.RandomForest
R CMD BATCH --no-save ./SVM/SVM.R                     ./SVM/SVM.out
touch Done.SVM
R CMD BATCH --no-save ./LogitConvergence/LogitConvergence.R \
                      ./LogitConvergence/LogitConvergence.out

rm cluster.sh.*
rm Done.*
