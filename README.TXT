Updated Readme on Nov 22nd
Github Repository:
  https://github.com/RahulJKVerma/Stats-215---Lab-4


1. Overview
  a. Please install the packages as mentioned in Pre-requisite below.
  b. We use Rmarkdown to create the writeup. 
  The first step is to open
  WriteupFinal2.Rmd in RStudio, change the working directory at line 28,
  and try to compile it with Knit PDF
  (recommended) or Knit Html, see if it works as expected. 
  Note: RMarkdown is not consistent, the plots might look out of place in your
  computer. To fix it you might need to resize the figure height and width. 

2. Reproduce
  We updated WriteupFinal.Rmd to WriteupFinal2.Rmd to make it more reproducible.
  You will need to run one job on cluster to generate the new model performance
  for the new data. You will need to log on to cluster:
  a. Clone git repository above. Copy the new images to the working directory
  folder (the one contain WriteupFinal2.RMD) such that we have image1.txt,
  image2.txt, and image3.txt
  > git clone https://github.com/RahulJKVerma/Stats-215---Lab-4
  Tip: Use scp to copy files from your computer to cluster. On your computer
  type e.g.
  > scp file.abc binyu@arwen:~/Documents/

  b. Submit the cluster.sh to cluster possibly in parallel
  > qsub -pe smp 5 cluster.sh
  It will take about 10 hours to finish. If you want faster result, you can edit
  cluster.sh to set number of job for SVM = 0. SVM takes 1-2 hour to run each
  job. With no SVM you should expect ~ 3 hours to finish. 

  c. Go to Rstudio now, and run WriteupFinal2.Rmd

##############################################################################
### Original README
##############################################################################

Github Repository:
  https://github.com/RahulJKVerma/Stats-215---Lab-4

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

The WriteupFinal.Rmd is the writeup
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
