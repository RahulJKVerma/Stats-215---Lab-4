library(parallel)
library(doParallel)
library(foreach)
library(rlecuyer)
library(nnet)
library(glmnet)
library(MASS)
working.directory = "~/Documents/lab4/Stats-215---Lab-4"
nCores <- as.numeric(Sys.getenv('NSLOTS'))
# nCores = 10
setwd(working.directory)
registerDoParallel(nCores)

source("DataProcessing.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 1,
                      fix.random = FALSE, standardize = TRUE)
data = l[[1]]

k = 3; n.images = 3;
RNGkind("L'Ecuyer-CMRG")
out <- foreach(i = 1:200) %dopar% {
  outsmall <- foreach(size = 3:12) %do% {
    cat('Starting', i, ',', size,'th job.\n', sep = ' ')
    train.blocks = sample(n.images*k^2, 15)
    train.idx = data$blockid %in% train.blocks
    model = nnet(label ~ NDAI + SD + CORR + DF + CF + 
                    BF   + AF + AN, 
                  data = data[train.idx,], linout = TRUE,
                  size = size)
    label.hat = predict(model, data[!train.idx, ])
    glmnet::auc(data[!train.idx,3], label.hat)
  }
}
# print(mean(unlist(out)))
save(out,file = "NeuralNet.RData")
