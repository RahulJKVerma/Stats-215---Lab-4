library(nnet)
library(MASS)
library(glmnet)
library(parallel)
library(doParallel)
library(foreach)
nCores = 1
registerDoParallel(nCores)

setwd("~/Dropbox/School/ST215/Lab/lab4/")

source("DataProcessing.R")
source("PerformanceMetrics.R")
l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 15/27,
                      fix.random = FALSE)
train = l[[1]]; test = l[[2]]; rm(l);
########################################################################
### 1. Linear Regression
########################################################################
train$logSD = log(train$SD+1)
test$logSD  = log(test$SD +1)
linreg.fit = lm(label ~ NDAI + SD + CORR + DF + CF + 
                        BF   + AF + AN + logSD, 
                data = train)
label.hat = predict.lm(linreg.fit, test)
### Measuring Linear Regression Performance
auc(test$label, label.hat)
accuracy(cutOff(label.hat,0.5), test$label)
# meanError(cutOff(label.hat), test$label)
### Picking the best cut off threshold
cutOffGridSearch(test$label, label.hat, method = accuracy)

#######################################################################
### 2. Logistic Regression
#######################################################################
logreg.fit = glm(label ~ NDAI + SD + CORR + DF + CF +
                              BF   + AF + AN,
                      data = train, family = binomial(link = "logit"))
label.hat2 = as.numeric(predict(logreg.fit, test, type = "response"))
auc(test$label, label.hat2)
accuracy(cutOff(label.hat2), test$label)

#######################################################################
### 3. Ordered Logit. For 3 classes only
#######################################################################
ordlog.fit = polr(factor(label) ~ NDAI + SD + CORR + DF + CF +
                    BF   + AF + AN + logSD, data = train, method = "logistic")
label.hat3 = as.numeric(predict(ordlog.fit, test))
accuracy(label.hat3, test$label)
meanError(label.hat3, test$label)

#######################################################################
### 4. GLMNET
#######################################################################
glmnet.fit = glmnet(as.matrix(train[,4:11]), as.numeric(train[,3]), 
                    family = "binomial", standardize = TRUE, 
                    intercept = TRUE)
# label.hat4 is a matrix, each column is one possible yhat, for a 
# corresponding lambda - regularization parameter. 100 columns in total
label.hat4 = predict(glmnet.fit, as.matrix(test[,4:11]), type = "response")
accuracy(cutOff(label.hat4[,40]), test$label)
system.time((
cvglm.fit = cv.glmnet(as.matrix(train[,4:11]), 
                      as.numeric(train[,3]), family = "binomial",
                      standardize = TRUE, intercept = TRUE,
                      type.measure = "auc",
                      foldid = getFold(train$blockid),
                      parallel = FALSE)
))
label.hat6 = predict(cvglm.fit, as.matrix(test[,4:11]), type = "response")
auc(test$label, label.hat6)
accuracy(cutOff(label.hat6), test$label)

########################################################################
### 5. Polynomial Logistic
########################################################################
logpol.fit = glm(label ~ (NDAI + SD + CORR + DF + CF +
                        BF   + AF + AN )^2,
                      data = train, family = binomial(link = "logit"))
label.hat5 = as.numeric(predict(logpol.fit, test, type = "response"))

auc(test$label, label.hat5)
accuracy(cutOff(label.hat5), test$label)


