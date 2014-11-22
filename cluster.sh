#!/bin/bash
export OMP_NUM_THREADS=$NSLOTS
export DIR="~/Documents/Lab4Fixed/Stats-215---Lab-4/"
export NJOBS=1


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

rm cluster.sh.*
rm Done.*
