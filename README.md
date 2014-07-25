Project1
========
This is the project homework for the COURSERA Class "Getting and Cleaning Data"

###Set workind directory
First I set the working directory as "C:/R/UCI HAR Dataset/"
```{R}
setwd("C:/R/UCI HAR Dataset/")
```
###Read
Read test data and then label it
```{R}
sub_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
test <- cbind(Subject=sub_test, Type="TEST",Y=y_test, X_test)
```
Read train data and then label it
```{R}
sub_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
train <- cbind(Subject=sub_train, Type="TRAIN",Y=y_train, X_train)
```
###Merge
Merge train and test and sort the list by Subject number
```{R}
HARdata <- rbind(train,test)
names(HARdata)[1] <- "Subject"
names(HARdata)[3] <- "Activity"
HARdata <- HARdata[order(HARdata$Subject),]
```
read features and migrate names to HARdata
```{R}
features <- read.table("features.txt")
names(HARdata)[4:ncol(HARdata)] <- as.character(features[,2])
```
###Select "mean" and "std"
select cols containing "mean" and "std" into HARdatameanstd
```{R}
meanstd <- c(grep("mean",names(HARdata),ignore.case=T), grep("std",names(HARdata),ignore.case=T))
meanstdColNum <- c(1,2,3, meanstd)
meanstdColNum <- meanstdColNum[order(meanstdColNum)]
HARdatameanstd <- HARdata[,meanstdColNum]
```
read activity labels and allocate them into the data set
```{R}
actlabels <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
for( i in 1:length(actlabels))
  {
    HARdatameanstd$Activity[HARdatameanstd$Activity == i] <- actlabels[i]
  }
```
write the data set if you want
write.csv(HARdatameanstd, file="HARdatameanstd.csv")

###Calculating Averages
create second data set with averages of each variable
```{R}
HARdatamean <- as.data.frame(matrix(NA,1,ncol(HARdatameanstd)))
names(HARdatamean) <- names(HARdatameanstd)
```
Calculating averages by looping within Subjects and Activity types
```{R}
for( i in 1:max(HARdatameanstd$Subject))
  {
  ##loop in Activity
  for( j in 1:6)
    {
    RowLogical <- HARdatameanstd$Subject == i & HARdatameanstd$Activity == actlabels[j]
    ##write Subject number, test/train and activity
    HARdatamean[i*6+j-6,1:3] <- as.character(HARdatameanstd[RowLogical,1:3][1,])
    ##calculate colMeans of each item
    HARdatamean[i*6+j-6,4:ncol(HARdatameanstd)] <- colMeans(HARdatameanstd[RowLogical,4:ncol(HARdatameanstd)])
    }
  }
```
relabel the Type...
```{R}
HARdatamean$Type[HARdatamean$Type == 1] <- "TRAIN"
HARdatamean$Type[HARdatamean$Type == 2] <- "TEST"
```
write the data set2 if you want
write.csv(HARdatamean, file="HARdatamean.csv")





