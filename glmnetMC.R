library(parallel)
library(doParallel)
library(foreach)
library(rlecuyer)
library(glmnet)

working.directory = "~/Documents/lab4/Stats-215---Lab-4"
# nCores <- as.numeric(Sys.getenv('NSLOTS'))
nCores = 5 
setwd(working.directory)
registerDoParallel(nCores)

source("DataProcessing.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 1,
                      fix.random = TRUE)
data = l[[1]]

k = 3; n.images = 3;
RNGkind("L'Ecuyer-CMRG")
out <- foreach(i = 1:2) %do% {
  cat('Starting', i, 'th job.\n', sep = ' ')
  train.blocks = sample(n.images*k^2, 15)
  train.idx = data$blockid %in% train.blocks
  model = cv.glmnet(as.matrix(data[train.idx,4:11]), 
                      as.numeric(data[train.idx,3]), family = "binomial",
                      standardize = FALSE, intercept = FALSE,
                      type.measure = "auc",
                      foldid = ceiling(getFold(train$blockid)/3),
                      parallel = FALSE)
  label.hat = predict(model, data[!train.idx,4:11], type = "response")
  auc(data[!train.idx,3], label.hat)
}
print(out)
save(out,file = "glmnetAUC.RData")
