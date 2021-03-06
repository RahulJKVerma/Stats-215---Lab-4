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
n.jobs = as.numeric(Sys.getenv('NJOBS_MED'))

source("DataProcessing.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 1,
                      fix.random = TRUE, standardize = TRUE)
data = l[[1]]; 
rm(l); rm(image1); rm(image2); rm(image3); 
gc();

k = 3; n.images = 3;
RNGkind("L'Ecuyer-CMRG")
out <- foreach(i = 1:n.jobs) %dopar% {
  cat('Starting', i, 'th job.\n', sep = ' ')
  train.blocks = sample(n.images*k^2, 15)
  train.idx = data$blockid %in% train.blocks
  model = cv.glmnet(as.matrix(data[train.idx,4:11]), 
                      as.numeric(data[train.idx,3]), family = "binomial",
                      standardize = FALSE, intercept = FALSE,
                      type.measure = "auc",
                      foldid = ceiling(getFold(data$blockid[train.idx])/3),
                      parallel = FALSE)
  label.hat = predict(model, as.matrix(data[!train.idx,4:11]), type = "response")
  auc(data[!train.idx,3], label.hat)
}
print(mean(unlist(out)))
save(out,file = "./LogitCV/LogitCV.RData")
Sys.time()
Sys.Date()
