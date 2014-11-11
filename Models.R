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
l = getTrainTestBlock(list(image1, image2, image3), k = 3, 
                      train.pct = 15/27, fix.random = TRUE, 
                      standardize = TRUE)
train = l[[1]]; test = l[[2]]; rm(l);
########################################################################
### 1. Linear Regression
########################################################################
linreg.fit = lm(label ~ NDAI + SD + CORR + DF + CF + 
                        BF   + AF + AN, 
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
label.hat2 = predict(logreg.fit, test, type = "response")
auc(test$label, label.hat2)
accuracy(cutOff(label.hat2), test$label)

plot(label.hat2, test$label)
ggplot() + geom_density(aes(x = label.hat2)) 

### 2.2. Polynomial Logistic
logpol.fit = glm(label ~ (NDAI + SD + CORR + DF + CF +
                            BF   + AF + AN )^2,
                 data = train, family = binomial(link = "logit"))
label.hat22 = as.numeric(predict(logpol.fit, test, type = "response"))
auc(test$label, label.hat22)
accuracy(cutOff(label.hat22), test$label)


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
ld = c(1,0.5,0.2,0.1,0.05,0.02,0.01,0.005,0.002,0.001,0.0005,0.0002,0.0001,
       5e-5, 2e-5, 1e-5, 5e-6, 2e-6, 1e-6)
glmnet.fit = glmnet(as.matrix(train[,4:11]), as.numeric(train[,3]), 
                    family = "binomial", standardize = TRUE, 
                    intercept = TRUE, lambda = ld)
# label.hat4 is a matrix, each column is one possible yhat, for a 
# corresponding lambda - regularization parameter. 100 columns in total
label.hat4 = predict(glmnet.fit, as.matrix(test[,4:11]), type = "response")
sapply(1:length(ld), function(i) auc(test$label, label.hat4[,i]))

### 4.2. CVGLMNET
cvglm.fit2 = cv.glmnet(as.matrix(train[,4:11]), 
                      as.numeric(train[,3]), family = "binomial",
                      standardize = FALSE, intercept = FALSE,
                      type.measure = "auc",
                      foldid = ceiling(getFold(train$blockid)/3),
                      parallel = FALSE)
label.hat42 = predict(cvglm.fit2, as.matrix(test[,4:11]), type = "response")
auc(test$label, label.hat42)
accuracy(cutOff(label.hat42), test$label)

### 4.3. GLMNET Polynomial
cvglm.fit3 = cv.glmnet(model.matrix(~ (NDAI + SD + CORR + DF + CF +
                                      BF + AF + AN - 1), train), 
                       as.numeric(train[,3]), family = "binomial",
                       standardize = FALSE, intercept = FALSE,
                       type.measure = "auc",
                       foldid = ceiling(getFold(train$blockid)/3),
                       parallel = FALSE)
label.hat43 = predict(cvglm.fit3, model.matrix(~ (NDAI + SD + CORR + 
                      DF + CF + BF + AF + AN - 1), test), type = "response")
auc(test$label, label.hat43)

##########################################################################
### 5. Linear Discriminant Analysis
##########################################################################
qda.fit = lda(label ~ NDAI + SD + CORR + DF + CF +
                   BF   + AF + AN,
                 data = train)
label.hat5 = (predict(qda.fit, test))
auc(test$label, label.hat5$x)
accuracy(test$label, label.hat5$class)

