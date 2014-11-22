library(glmnet)
library(knitr)

source("DataProcessing.R")
# Get Train and Test and Save to file for RMarkdown
SaveTrainTestToFile = function()
{
  l = getTrainTestBlock(list(image1, image2, image3), k = 3, 
                        train.pct = 15/27, fix.random = TRUE, 
                        standardize = TRUE)
  train = l[[1]]; 
  test = l[[2]]; 
  rm(l);
  save(train, file = "train.RData")
  save(test, file = "test.RData")
}

GetAUCTable = function(data = train)
{
  inputs.col = names(data)[4:11]
  res = data[1,inputs.col]
  row.names(res) = "AUC"
  for (column in inputs.col)
  {
    res[1,column] = glmnet::auc(train$label, train[,column])
  }
  kable(res, digits = 3)
}
GetCorTable = function(data = train)
{
  inputs.col = names(train)[4:11]
  kable(cor(train[train$label == 1, inputs.col]), digit = 2)
}



