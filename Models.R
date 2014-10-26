source("DataProcessing.R")
source("PerformanceMetrics.R")

########################################################################
### 1. Linear Regression
########################################################################
linreg.fit = lm(label ~ NDAI + SD + CORR + DF + CF + BF + AF + AN, 
                data = train)
label.hat = predict.lm(linreg.fit, test)

### Measuring Linear Regression Performance
accuracy(cutOff(label.hat), test$label)
meanError(cutOff(label.hat), test$label)
### Picking the best cut off threshold

#######################################################################
### 2. Logistic Regression
#######################################################################


