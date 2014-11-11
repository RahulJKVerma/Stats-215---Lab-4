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
ntrees = c(10, 20, 40, 80, 160, 320, 640)
k = 3; n.images = 3;
RNGkind("L'Ecuyer-CMRG")
out <- foreach(i = 161:200) %dopar% {
  outsmall <- foreach(j = 1:length(ntrees)) %do% {
    cat('Starting', i, ',', j,'th job.\n', sep = ' ')
    train.blocks = sample(n.images*k^2, 15)
    train.idx = data$blockid %in% train.blocks
    model = randomForest(factor(label) ~ NDAI + SD + CORR + DF + CF + 
                    BF   + AF + AN, 
                  data = data[train.idx,],
                  ntree = ntrees[j])
    label.hat = predict(model, data[!train.idx, ], type = "prob")
    a = glmnet::auc(data[!train.idx,3], label.hat[,2])
    print(a)
    a
  }
}
# print(mean(unlist(out)))
save(out,file = "RandomForest161-200.RData")
