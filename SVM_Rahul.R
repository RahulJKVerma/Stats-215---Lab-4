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

# Add informative column names.
collabs <- c('y','x','label','NDAI','SD','CORR','DF','CF','BF','AF','AN')
names(image1) <- collabs
names(image2) <- collabs
names(image3) <- collabs

# Function to sample data
getTrainTest = function(list.images, train.percentage = 0.60)
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


#########################################################################
####### Selecting NDAI, SD and DF as the features used for classification
#########################################################################

## Finding the tuning parameters

tuning.parameters <- tune.svm(label~., data = train[,c(3,4,5,7)], gamma = 10^(-6:-1), cost = 10^(-1:1))
summary(tuning.parameters)

#Training the model
svm.model  <- svm(label~., data = train[,c(3,4,5,7)], kernel="linear", gamma=0.001, cost=10) 
summary(model)

#Prediction
svm.predict <- predict(model, test[,-1])
classication.tab <- table(pred = svm.predict, true = test[,3])
classification.tab