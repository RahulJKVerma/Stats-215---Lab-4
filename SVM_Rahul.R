#install.packages('e1071',dependencies=TRUE)

library(e1071)

#########################################################################
### Hoang's code for creating a training and testing data set ###
#########################################################################

setwd("~/Dropbox/Fall 14/Stats 215/Stats-215---Lab-4/")
options(max.print = 1000)

#########################################################################
### 1. Load Data
#########################################################################
# Get the data for three images
image1 <- read.table('image1.txt', header=F)
image2 <- read.table('image2.txt', header=F)
image3 <- read.table('image3.txt', header=F)

#image1 <- image1[2000:18000,]
#image2 <- image2[2000:18000,]
#image3 <- image3[2000:18000,]



# Add informative column names.
collabs <- c('y','x','label','NDAI','SD','CORR','DF','CF','BF','AF','AN')
names(image1) <- collabs
names(image2) <- collabs
names(image3) <- collabs

# Function to sample data
getTrainTest = function(list.images, train.percentage = 0.20)
{
  set.seed(1); n.images = length(list.images) 
  n.row = nrow(list.images[[1]])
  train.index = sample(n.row, n.row*train.percentage)
  train = list.images[[1]][ train.index, ]
  test =  list.images[[1]][-train.index, ]
  i = 2;
  while (i <= n.images)
  {
    set.seed(i)
    n.row = nrow(list.images[[i]])
    train.index = sample(n.row, n.row*train.percentage)
    train = rbind(train, list.images[[i]][ train.index, ])
    test  = rbind(test,  list.images[[i]][-train.index, ])
    i = i + 1
  }
  return(list(train, test))
}
l = getTrainTest(list(image1, image2))
train = l[[1]]; test = l[[2]]; rm(l);

cutOff = function(label, thres = 0.5)
{
  # Given a number x, if x > thres, return 1,
  # if x < -thres, return -1.
  # if - thres <= x <= thres return 0
  # where label > 0.5, set to 1, the rest 0
  x = (label > thres) + 0.0
  # where label < -0.5 set to -1 instead
  x[label < -thres] = -1
  x
}

accuracy = function(label, label.hat)
{
  # Return the percentage of time predicting correctly
  # over total number of prediction.
  t = table(label, label.hat)
  sum(diag(t))/sum(t)
}


#########################################################################
####### Selecting NDAI, SD and DF as the features used for classification
#########################################################################

## Finding the tuning parameters

#tuning.parameters <- tune.svm(label~., data = train[,c(3,4,5,7)], gamma = 10^(-6:-1), cost = 10^(-1:1))
#summary(tuning.parameters)

start.time1 <- Sys.time()
#Training the model
svm.model  <- svm(label~., data = train[,c(3,4,5,7)], kernel="linear", gamma=0.01, cost=10) 
summary(svm.model)

duration.1 <- Sys.time() - start.time1
print(duration.1)

#Prediction
svm.predict <- predict(svm.model, test[,c(4,5,7)])

svm.predict.cutoff <- cutOff(svm.predict)

classification.tab <- table(pred = svm.predict.cutoff, true = test[,3])
accuracy(svm.predict.cutoff, test[,3])
classification.tab
