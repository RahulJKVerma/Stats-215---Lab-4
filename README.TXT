I. Pre-requisite: 
Please install these R packages beforehand
  a. dplyr
  b. ggplot2
  c. corrplot
  d. glmnet
  e. e1071
  f. randomForest
  g. jpeg
  h. pROC

Please set the correct path inside Models.R
Please make sure you have images file named image1.txt, image2.txt, and 
image3.txt in this folder. Otherwise change the DataProcessing.R to read the
appropriate images. 

II. Main File

  The main file is Models.R. Inside this file, it calls DataProcessing.R to 
import images, split images into train and test. It also calls 
PerformanceMetrics.R, which contains functions that evaluate model performance. 
There are 7 models inside Models.R. 

User can step through them, fit the data to 
train set and evaluate auc or accuracy on the test set. Note that auc should 
apply on the continuous yhat, while accuracy should be apply on the 0,1 yhat. 
There is a function cutOff to cut a continuous probability vector into 0 and 1.

III. Secondary File

  1. DataProcessing.R contains two functions that load data and split randomly
by row (the first function) into train and test, or split randomly by blocks
(the second function) into train and test. The final function is for using 
with cross validation.
  2. PerformanceMetrics.R contains multiple functions to assess the performance
of models
  3. ModelName folder, e.g. NeuralNet folder. These folders with model names 
contain the files needed to run the job on department clusters. They also 
contain output of jobs. 
  4. Ignore the .RData file, they are data used to create the write up. 
