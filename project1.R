##read train and test
setwd("C:/R/UCI HAR Dataset/test/")
  sub_test <- read.table("subject_test.txt")
  X_test <- read.table("X_test.txt")
  y_test <- read.table("y_test.txt")
  test <- cbind(Subject=sub_test, Type="TEST", X_test, Y=y_test)

setwd("C:/R/UCI HAR Dataset/train/")
  sub_train <- read.table("subject_train.txt")
  X_train <- read.table("X_train.txt")
  y_train <- read.table("y_train.txt")
  train <- cbind(Subject=sub_train, Type="TRAIN", X_train, Y=y_train)

## merge train and test
  HARdata <- rbind(train,test)
  names(HARdata)[1] <- "Subject"
  names(HARdata)[ncol(HARdata)] <- "Y"
  HARdata <- HARdata[order(HARdata$Subject),]

## to select Mean and Std measurements = =
## so I build up a list containing Mean and std... so sad.
  