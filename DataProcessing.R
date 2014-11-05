setwd("~/Dropbox/School/ST215/Lab/lab4/")
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
rm(collabs)

##########################################################################
### 2. Sample Data randomly in row
### Function to sample data. E.g. It uses 60% of rows from image1
### and image2 randomly as train data, uses the remaining 40%
### rows from image1 and image2 as test data. Image3 is kept
### as a complete out of sample testing dataset. 
##########################################################################
getTrainTest = function(list.images, train.percentage = 0.60, rid.zero = TRUE)
{
  if (rid.zero)
  {
    for (i in 1:length(list.images))
    {
      list.images[[i]] = list.images[[i]][list.images[[i]]$label != 0, ]
    }
  }
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
  if (rid.zero)
  {
    train$label = (1+train$label)/2
    test$label  = (1+test$label)/2
  }
  return(list(train, test))
}
# l = getTrainTest(list(image1, image2))
# train = l[[1]]; test = l[[2]]; rm(l);

###########################################################################
### 3. Sample the data in blocks (not in row). E.g. for each image, 
### divide it into 3 by 3 small images. Then get 5 of these 9 blocks 
### randomly. 
###########################################################################
getTrainTestBlock = function(list.images, k = 3, rid.zero = TRUE,
                 train.pct = 5/9, fix.random = TRUE)
{
  # Initialize result. 
  data = data.frame();
  i = 0
  for (img in list.images)
  {
    # Create a grid of k*k rectangular of the original images. 
    # Sample some rectangular randomly from these k*k rectangular
    # Column Block Index (0,1,...,k)
    block.x = floor(k*(img$x - min(img$x))/(max(img$x)-min(img$x)+1))
    # Row Block Index (0,1,...,k)
    block.y = floor(k*(img$y - min(img$y))/(max(img$y)-min(img$y)+1))
    # Aggregate Index (1,2,...,k^2)
    block  = k*block.y+block.x + 1 + i*k^2
    img$blockid = block
    data = rbind(data, img)
    i = i + 1
  }
  n.images = length(list.images)
  if (fix.random) set.seed(1);
  train.blocks = sample(n.images*k^2, round(train.pct*k^2*n.images))
  train.idx = data$blockid %in% train.blocks
  train = data[train.idx,]
  test  = data[!train.idx,]
  if (rid.zero)
  {
    train = train[train$label != 0,]; 
    test  = test[test$label != 0,]
  }
  return(list(train,test))
}
# l = getTrainTestBlock(list(image1, image2, image3),k=3, train.pct = 0/27)
# train = l[[1]]; test = l[[2]]; rm(l);
