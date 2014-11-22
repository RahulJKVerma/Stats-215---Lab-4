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
l = getTrainTestBlock(list(image1, image2, image3),k=6, train.pct = 1,
                      fix.random = TRUE, standardize = TRUE)
data = l[[1]]
rm(image1); rm(image2); rm(image3); rm(l); gc();

# We have 3*6^2 = 108 blocks. Can run model for one block, then two 
# until 108 blocks. 

out <- foreach(i = 1:108) %do% {
  cat('Starting', i, 'th job.\n', sep = ' ')
  model = glm(label ~ NDAI + SD + CORR + DF + CF + BF   + AF + AN, 
               data = data[data$blockid <= i,], 
               family = binomial(link = "logit"))
  model$coefficients
}
print(out)
save(out,file = "./LogitConvergence/LogitConvergence.RData")
Sys.time()
Sys.Date()
