library(dplyr)
library(ggplot2)

setwd("/Users/andrewaschka/Desktop/Clouds")
# Get the data for three images

image1 <- read.table('image1.txt', header=F)
image2 <- read.table('image2.txt', header=F)
image3 <- read.table('image3.txt', header=F)

# Add informative column names.
collabs <- c('y','x','label','NDAI','SD','CORR','DF','CF','BF','AF','AN')
names(image1) <- collabs
names(image2) <- collabs
names(image3) <- collabs

head(image1)
summary(image1)


########Image 1
# The raw image (red band, from nadir).
ggplot(image1) + geom_point(aes(x=x, y=y, color=AN))

# The classification.
ggplot(image1) + geom_point(aes(x=x, y=y, color=factor(label)))

# Class conditional densities.
ggplot(image1) + geom_density(aes(x=AN, group=factor(label), fill=factor(label)), alpha=0.5)


########Image 2
# The raw image (red band, from nadir).
ggplot(image2) + geom_point(aes(x=x, y=y, color=AN))

# The classification.
ggplot(image2) + geom_point(aes(x=x, y=y, color=factor(label)))

# Class conditional densities.
ggplot(image2) + geom_density(aes(x=AN, group=factor(label), fill=factor(label)), alpha=0.5)


########Image 3
# The raw image (red band, from nadir).
ggplot(image3) + geom_point(aes(x=x, y=y, color=AN))

# The classification.
ggplot(image3) + geom_point(aes(x=x, y=y, color=factor(label)))

# Class conditional densities.
ggplot(image3) + geom_density(aes(x=AN, group=factor(label), fill=factor(label)), alpha=0.5)



#### For all 5 camera angles for Image 1
# Class conditional densities.
ggplot(image1) + geom_density(aes(x=DF, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image1) + geom_density(aes(x=CF, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image1) + geom_density(aes(x=BF, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image1) + geom_density(aes(x=AF, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image1) + geom_density(aes(x=AN, group=factor(label), fill=factor(label)), alpha=0.5)

#### For all 5 camera angles for Image 2
# Class conditional densities.
ggplot(image2) + geom_density(aes(x=DF, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image2) + geom_density(aes(x=CF, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image2) + geom_density(aes(x=BF, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image2) + geom_density(aes(x=AF, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image2) + geom_density(aes(x=AN, group=factor(label), fill=factor(label)), alpha=0.5)


###For CORR
# Class conditional densities.
ggplot(image1) + geom_density(aes(x=CORR, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image2) + geom_density(aes(x=CORR, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image3) + geom_density(aes(x=CORR, group=factor(label), fill=factor(label)), alpha=0.5)


###For SD
# Class conditional densities.
ggplot(image1) + geom_density(aes(x=SD, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image2) + geom_density(aes(x=SD, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image3) + geom_density(aes(x=SD, group=factor(label), fill=factor(label)), alpha=0.5)



#####For NDAI
# Class conditional densities.
ggplot(image1) + geom_density(aes(x=NDAI, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image2) + geom_density(aes(x=NDAI, group=factor(label), fill=factor(label)), alpha=0.5)
ggplot(image3) + geom_density(aes(x=NDAI, group=factor(label), fill=factor(label)), alpha=0.5)



