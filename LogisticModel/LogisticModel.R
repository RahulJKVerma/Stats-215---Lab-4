library(parallel)
library(doParallel)
library(foreach)
library(rlecuyer)
library(glmnet)

working.directory = Sys.getenv('DIR')
nCores <- as.numeric(Sys.getenv('NSLOTS'))
print(working.directory)
setwd(working.directory)
registerDoParallel(nCores)
n.jobs = as.numeric(Sys.getenv('NJOBS_HIGH'))

source("DataProcessing.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 1,
                      fix.random = FALSE, standardize = TRUE)
data = l[[1]]; rm(image1); rm(image2); rm(image3); gc();

rm(image1)
rm(image2)
rm(image3)
rm(l)
gc()

k = 3; n.images = 3;
RNGkind("L'Ecuyer-CMRG")
out <- foreach(i = 1:n.jobs) %dopar% {
  cat('Starting', i, 'th job.\n', sep = ' ')
  train.blocks = sample(n.images*k^2, 15)
  train.idx = data$blockid %in% train.blocks
  model = glm(label ~ NDAI + SD + CORR + DF + CF + BF   + AF + AN, 
               data = data[train.idx,], 
               family = binomial(link = "logit"))
  label.hat = predict(model, data[!train.idx, ], type = "response")
  auc(data[!train.idx,3], label.hat)
}
print(mean(unlist(out)))
save(out,file = "./LogisticModel/LogisticModel.RData")
Sys.time()
Sys.Date()
