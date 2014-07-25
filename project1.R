##read test data
setwd("C:/R/UCI HAR Dataset/")
sub_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
test <- cbind(Subject=sub_test, Type="TEST",Y=y_test, X_test)

##read training data
sub_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
train <- cbind(Subject=sub_train, Type="TRAIN",Y=y_train, X_train)

## merge train and test and sort the list by Subject number
HARdata <- rbind(train,test)
names(HARdata)[1] <- "Subject"
names(HARdata)[3] <- "Activity"
HARdata <- HARdata[order(HARdata$Subject),]

## read features and migrate names to HARdata
features <- read.table("features.txt")
names(HARdata)[4:ncol(HARdata)] <- as.character(features[,2])

## select cols containing "mean" and "std" into HARdatameanstd
meanstd <- c(grep("mean",names(HARdata),ignore.case=T), grep("std",names(HARdata),ignore.case=T))
meanstdColNum <- c(1,2,3, meanstd)
meanstdColNum <- meanstdColNum[order(meanstdColNum)]
HARdatameanstd <- HARdata[,meanstdColNum]

## read activity labels and allocate them into the data set
actlabels <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
for( i in 1:length(actlabels))
{
  HARdatameanstd$Activity[HARdatameanstd$Activity == i] <- actlabels[i]
}

##write the data set 
## write.csv(HARdatameanstd, file="HARdatameanstd.csv")

#second data set with averages of each variable
HARdatamean <- as.data.frame(matrix(NA,1,ncol(HARdatameanstd)))
names(HARdatamean) <- names(HARdatameanstd)

#loop in Subject
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
## relabel the Type...
HARdatamean$Type[HARdatamean$Type == 1] <- "TRAIN"
HARdatamean$Type[HARdatamean$Type == 2] <- "TEST"

##write the data set 
## write.csv(HARdatamean, file="HARdatamean.csv")
