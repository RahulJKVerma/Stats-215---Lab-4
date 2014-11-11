#install.packages('e1071',dependencies=TRUE)

library('e1071')
library('Rcpp')
library('microbenchmark')
library('foreach')
library('doParallel')
library('pROC')

setwd("~/Stats215")

#########################################################################
### Hoang's code for creating a training and testing data set ###
#########################################################################

source("DataProcessing.R")
source("PerformanceMetrics.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 15/27, fix.random = TRUE)
train = l[[1]]; test = l[[2]]; rm(l);

#########################################################################
####### Selecting NDAI, SD and DF as the features used for classification
#########################################################################

## Finding the tuning parameters

#tuning.parameters <- tune.svm(label~., data = train[,c(3,4,5,7)], gamma = 10^(-6:-1), cost = 10^(-1:1))
#summary(tuning.parameters)


#########################################################################
####### Setting cores
#########################################################################
ncores = 30
registerDoParallel(ncores)
#########################################################################
#######
#########################################################################

#start.time1 <- Sys.time()


#########################################################################
####### Foreach loop
#########################################################################



#l = getTrainTestBlock(list(image1, image2, image3),k=3,
#                      train.pct = 15/27, fix.random = TRUE)
#train = l[[1]]; test = l[[2]]; rm(l);

#Training the model
svm.model  <- svm(label~., data = train[,3:11], kernel="radial",  gamma=.01, cost = .01)

#summary(svm.model)
#duration.1 <- Sys.time() - start.time1
#print(duration.1)

#Prediction
svm.predict <- predict(svm.model, test[,4:11])

#svm.predict.cutoff <- cutOff(svm.predict)
#classification.tab <- table(pred = svm.predict.cutoff, true = test[1:1000,3])

AUC <- auc(roc(test[,3],svm.predict))
svm.predict.cutoff <- cutOffGridSearch(test[,3], svm.predict)

#return_value <- list(AUC ,k_value, c_value)
#classification.tab


AUC
#Area under the curve: 0.9729

#save(svm.predict.cutoff, svm.predict, train, test, file="grid_cutoff.RData")

