library(parallel)
library(doParallel)
library(foreach)
library(rlecuyer)
library(randomForest)
library(MASS)
library(glmnet)
working.directory = "~/Documents/lab4/Stats-215---Lab-4"
nCores <- as.numeric(Sys.getenv('NSLOTS'))
# nCores = 10
setwd(working.directory)
registerDoParallel(nCores)

source("DataProcessing.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 1,
                      fix.random = FALSE, standardize = TRUE)
data = l[[1]]
# ntrees = c(10, 20, 40, 80, 160, 320, 640)
k = 4; n.images = 3;
RNGkind("L'Ecuyer-CMRG")
out <- foreach(i = 1:27) %dopar% {
    cat('Starting', i, 'th job.\n', sep = ' ')
    model = randomForest(factor(label) ~ NDAI + SD + CORR + DF + CF + 
                    BF   + AF + AN, 
                  data = data[data$blockid <= i,],
                  ntree = 640)
   model$importance 
}
# print(mean(unlist(out)))
save(out,file = "RFConvergence.RData")
