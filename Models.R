library(nnet)
library(MASS)
library(pROC)

setwd("~/Dropbox/School/ST215/Lab/lab4/")
source("DataProcessing.R")
source("PerformanceMetrics.R")

########################################################################
### 1. Linear Regression
########################################################################
train$logSD = log(train$SD+1)
test$logSD  = log(test$SD +1)
linreg.fit = lm(label ~ NDAI + SD + CORR + DF + CF + 
                        BF   + AF + AN   + logSD, 
                data = train)
label.hat = predict.lm(linreg.fit, test)

### Measuring Linear Regression Performance
accuracy(cutOff(label.hat), test$label)
# meanError(cutOff(label.hat), test$label)
### Picking the best cut off threshold
cutOffGridSearch(test$label, label.hat, method = accuracy)


#######################################################################
### 2. Logistic Regression
#######################################################################
logreg.fit = multinom(label ~ NDAI + SD + CORR + DF + CF +
                              BF   + AF + AN + logSD,
                      data = train)
label.hat2 = as.numeric(predict(logreg.fit, test))
accuracy(label.hat2, test$label)
# label.hat2 = as.numeric(predict(logreg.fit, image3))
# accuracy(label.hat2, image3$label)

# meanError(label.hat2, test$label)

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
glmnet.fit = glmnet(as.matrix(train[,4:12]), as.numeric(train[,3]), 
                    family = "binomial", standardize = TRUE, 
                    intercept = TRUE)
# label.hat4 is a matrix, each column is one possible yhat, for a 
# corresponding lambda - regularization parameter. 100 columns in total
label.hat4 = predict(glmnet.fit, as.matrix(test[,4:12]), type = "response")
accuracy(cutOff(label.hat4[,40]), test$label)

########################################################################
### 5. Polynomial Logistic
########################################################################
logpol.fit = glm(label ~ (NDAI + SD + CORR + DF + CF +
                        BF   + AF + AN )^2,
                      data = train)
label.hat5 = as.numeric(predict(logpol.fit, test))
accuracy(cutOff(label.hat5), test$label)
label.hat5 = as.numeric(predict(logpol.fit, image3))
accuracy(cutOff(label.hat5), image3$label)

