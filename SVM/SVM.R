library(parallel)
library(doParallel)
library(foreach)
library(rlecuyer)
library(e1071)
library(MASS)
library(glmnet)


working.directory = Sys.getenv('DIR')
nCores <- as.numeric(Sys.getenv('NSLOTS'))
print(working.directory)
setwd(working.directory)
registerDoParallel(nCores)
n.jobs = as.numeric(Sys.getenv('NJOBS_LOW'))

if (n.jobs > 0) {
    source("DataProcessing.R")
    l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 1,
                          fix.random = FALSE, standardize = TRUE)
    data = l[[1]]; rm(image1); rm(image2); rm(image3)
    k = 3; n.images = 3;
    RNGkind("L'Ecuyer-CMRG")
    out <- foreach(i = 1:n.jobs) %dopar% {
        cat('Starting', i, 'th job.\n', sep = ' ')
        train.blocks = sample(n.images*k^2, 15)
        print(train.blocks)
        train.idx = data$blockid %in% train.blocks
        model = svm(label ~ NDAI + SD + CORR + DF + CF + 
                        BF   + AF + AN, 
                      data = data[train.idx,],
                      kernel = "radial",
                      gamma = 0.01,
                      cost = 0.01)
        print(model)
        label.hat = predict(model, data[!train.idx, ])
        print(label.hat)
        a = glmnet::auc(data[!train.idx,3], label.hat)
        print(a)
        a
    }
    # print(mean(unlist(out)))
    save(out,file = "./SVM/SVM.RData")
    Sys.time()
    Sys.Date()
}
