library(parallel)
library(doParallel)
library(foreach)
library(rlecuyer)
library(glmnet)

working.directory = "~/Documents/lab4/Stats-215---Lab-4"
nCores <- as.numeric(Sys.getenv('NSLOTS'))
# nCores = 6
setwd(working.directory)
registerDoParallel(nCores)

source("DataProcessing.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 1,
                      fix.random = TRUE, standardize = TRUE)
data = l[[1]]
rm(image1); rm(image2); rm(image3); rm(l); gc();
k = 3; n.images = 3;
RNGkind("L'Ecuyer-CMRG")
out <- foreach(i = 1:20) %dopar% {
  cat('Starting', i, 'th job.\n', sep = ' ')
  train.blocks = sample(n.images*k^2, 15)
  train.idx = data$blockid %in% train.blocks
  model = cv.glmnet(model.matrix( ~ (NDAI + SD + CORR + DF + CF + 
                      BF + AF + AN - 1)^2, data[train.idx,]), 
                      as.numeric(data[train.idx,3]), family = "binomial",
                      standardize = TRUE, intercept = FALSE,
                      type.measure = "auc",
                      foldid = ceiling(getFold(data$blockid[train.idx])/3),
                      parallel = FALSE)
  label.hat = predict(model, model.matrix( ~ (NDAI + SD + CORR + DF + CF + 
                      BF + AF + AN - 1)^2, data[!train.idx,]), type = "response")
  glmnet::auc(data[!train.idx,3], label.hat)
}
print(mean(unlist(out)))
save(out,file = "LogitPolyCV2.RData")
