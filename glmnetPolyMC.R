library(parallel)
library(doParallel)
library(foreach)
library(rlecuyer)
library(glmnet)

working.directory = "~/Documents/lab4/Stats-215---Lab-4"
working.directory = "~/Dropbox/School/ST215/lab4p/"
# nCores <- as.numeric(Sys.getenv('NSLOTS'))
nCores = 4
setwd(working.directory)
registerDoParallel(nCores)

source("DataProcessing.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 1,
                      fix.random = TRUE)
data = l[[1]]
rm(image1); rm(image2); rm(image3); rm(l); gc();
k = 3; n.images = 3;
RNGkind("L'Ecuyer-CMRG")
out <- foreach(i = 1:200) %dopar% {
  cat('Starting', i, 'th job.\n', sep = ' ')
  train.blocks = sample(n.images*k^2, 15)
  train.idx = data$blockid %in% train.blocks
  model = cv.glmnet(model.matrix(~ (NDAI + SD + CORR + DF + CF + 
                      BF + AF + AN)^2, data[train.idx,]), 
                      as.numeric(data[train.idx,3]), family = "binomial",
                      standardize = FALSE, intercept = FALSE,
                      type.measure = "auc",
                      foldid = ceiling(getFold(data$blockid[train.idx])/3),
                      parallel = FALSE)
  label.hat = predict(model, model.matrix(~ (NDAI + SD + CORR + DF + CF + 
                      BF + AF + AN)^2, data[!train.idx,]), type = "response")
  auc(data[!train.idx,3], label.hat)
}
print(out)
save(out,file = "glmnetPolyMC.RData")
