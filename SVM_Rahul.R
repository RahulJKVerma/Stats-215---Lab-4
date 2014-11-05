#install.packages('e1071',dependencies=TRUE)

library('e1071')
library('Rcpp')
library('microbenchmark')
library('foreach')
library('doParallel')

setwd("~/Dropbox/Fall 14/Stats 215/Stats-215---Lab-4")
#########################################################################
### Hoang's code for creating a training and testing data set ###
#########################################################################

source("DataProcessing.R")
source("PerformanceMetrics.R")


#########################################################################
####### Selecting NDAI, SD and DF as the features used for classification
#########################################################################

## Finding the tuning parameters

#tuning.parameters <- tune.svm(label~., data = train[,c(3,4,5,7)], gamma = 10^(-6:-1), cost = 10^(-1:1))
#summary(tuning.parameters)

ncores = 7
registerDoParallel(ncores)

start.time1 <- Sys.time()
#Training the model
parallel.results <- foreach (.verbose = TRUE, k = c(0.001,0.01,0.1,1,5,10,100)) %dopar% {
  
  svm.model  <- svm(label~., data = train[,c(3,4,5,7)], kernel="linear",  cost=k) 
  #summary(svm.model)
  #duration.1 <- Sys.time() - start.time1
  #print(duration.1)

  #Prediction
  svm.predict <- predict(svm.model, test[,c(4,5,7)])
  svm.predict.cutoff <- cutOff(svm.predict)
  #classification.tab <- table(pred = svm.predict.cutoff, true = test[1:1000,3])
  accuracy(svm.predict.cutoff, test[,3])
  #classification.tab
}

