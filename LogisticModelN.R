library(parallel)
library(doParallel)
library(foreach)
library(rlecuyer)
library(glmnet)

working.directory = "~/Documents/lab4/Stats-215---Lab-4"
# nCores <- as.numeric(Sys.getenv('NSLOTS'))
nCores = 4
setwd(working.directory)
registerDoParallel(nCores)

source("DataProcessing.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 1,
                      fix.random = TRUE)
data = l[[1]]

out <- foreach(i = 1:27) %dopar% {
  cat('Starting', i, 'th job.\n', sep = ' ')
  model = glm(label ~ NDAI + SD + CORR + DF + CF + BF   + AF + AN, 
               data = data[data$blockid <= i,], 
               family = binomial(link = "logit"))
  model$coefficients
}
print(out)
save(out,file = "LogisticModelN.RData")
