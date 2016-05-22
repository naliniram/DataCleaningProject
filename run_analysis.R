# Required packages
require(sqldf)
require(data.table)

# setting the current working directory
setwd("D:/Training/Coursera/Data cleansing project for week 4")

#Reading Train DataSets
SubjectTrain <- read.table("train/subject_train.txt")
ActivityTrain <- read.table("train/Y_train.txt")
ObservationsTrain <- read.table("train/X_train.txt")

# Read required reference tables
Feature <- read.table("features.txt")
ActivityLabel <- data.table(read.table("activity_labels.txt"))
names(ActivityLabel) <- c("ActivityL", "ActivityDescription")

#compile Train DataSet
names(ObservationsTrain)<- Feature$V2
names(SubjectTrain) <- "Subject"
names(ActivityTrain) <- "Activity"
TrainDataSet <- cbind(SubjectTrain,ActivityTrain,ObservationsTrain)

#Read Test Data
SubjectTest <- read.table("test/subject_test.txt")
ActivityTest <- read.table("test/Y_test.txt")
ObservationsTest <- read.table("test/X_test.txt")

#compile Train DataSet
names(ObservationsTest)<- Feature$V2
names(SubjectTest) <- "Subject"
names(ActivityTest) <- "Activity"
TestDataSet <- cbind(SubjectTest,ActivityTest,ObservationsTest)

# Combine TrainDataSet and TestDataSet to a single CompleteDataSet
CompleteDataSet <- rbind(TrainDataSet, TestDataSet)
TidyDataSet <- data.table(CompleteDataSet[, c("Subject","Activity",
                                   grep("std",names(CompleteDataSet),value = TRUE, fixed = TRUE),
                                   grep("mean()", names(CompleteDataSet),value = TRUE, fixed =TRUE))])

# Finding the mean and standarddeviation columnnames
grep("std",names(CompleteDataSet),value = TRUE, fixed = TRUE)
grep("mean()", names(CompleteDataSet),value = TRUE, fixed =TRUE)

#Joining TidyDataSet and ActivityLabel
TidyDataSet <- sqldf("select * from TidyDataSet inner join ActivityLabel on TidydataSet.Activity = ActivityLabel.ActivityL")
TidyDataSet <- TidyDataSet[, c(-2, -69)]

# Summarizing TidyDataSet By Subject and Activity

# MeanSD<-TidyDataSet[,lapply(SD,mean), by=c("Subject","ActivityDescription")]

# Removing "-,()"from the columnnames
names(TidyDataSet) <- gsub("[-()]","", names(TidyDataSet))
# To keep avg, () and ,for the column names
paste("avg(",names(TidyDataSet),"),",sep = "")


IndependentDataSet <-    sqldf("select Subject, ActivityDescription, 
                  avg(tBodyAccstdX),
                  avg(tBodyAccstdY),
                  avg(tBodyAccstdZ),
                  avg(tGravityAccstdX),
                  avg(tGravityAccstdY),
                  avg(tGravityAccstdZ),
                  avg(tBodyAccJerkstdX),
                  avg(tBodyAccJerkstdY),
                  avg(tBodyAccJerkstdZ),
                  avg(tBodyGyrostdX),
                  avg(tBodyGyrostdY),
                  avg(tBodyGyrostdZ),
                  avg(tBodyGyroJerkstdX),
                  avg(tBodyGyroJerkstdY),
                  avg(tBodyGyroJerkstdZ),
                  avg(tBodyAccMagstd),
                  avg(tGravityAccMagstd),
                  avg(tBodyAccJerkMagstd),
                  avg(tBodyGyroMagstd),
                  avg(tBodyGyroJerkMagstd),
                  avg(fBodyAccstdX),
                  avg(fBodyAccstdY),
                  avg(fBodyAccstdZ),
                  avg(fBodyAccJerkstdX),
                  avg(fBodyAccJerkstdY),
                  avg(fBodyAccJerkstdZ),
                  avg(fBodyGyrostdX),
                  avg(fBodyGyrostdY),
                  avg(fBodyGyrostdZ),
                  avg(fBodyAccMagstd),
                  avg(fBodyBodyAccJerkMagstd),
                  avg(fBodyBodyGyroMagstd),
                  avg(fBodyBodyGyroJerkMagstd),
                  avg(tBodyAccmeanX),
                  avg(tBodyAccmeanY),
                  avg(tBodyAccmeanZ),
                  avg(tGravityAccmeanX),
                  avg(tGravityAccmeanY),
                  avg(tGravityAccmeanZ),
                  avg(tBodyAccJerkmeanX),
                  avg(tBodyAccJerkmeanY),
                  avg(tBodyAccJerkmeanZ),
                  avg(tBodyGyromeanX),
                  avg(tBodyGyromeanY),
                  avg(tBodyGyromeanZ),
                  avg(tBodyGyroJerkmeanX),
                  avg(tBodyGyroJerkmeanY),
                  avg(tBodyGyroJerkmeanZ),
                  avg(tBodyAccMagmean),
                  avg(tGravityAccMagmean),
                  avg(tBodyAccJerkMagmean),
                  avg(tBodyGyroMagmean),
                  avg(tBodyGyroJerkMagmean),
                  avg(fBodyAccmeanX),
                  avg(fBodyAccmeanY),
                  avg(fBodyAccmeanZ),
                  avg(fBodyAccJerkmeanX),
                  avg(fBodyAccJerkmeanY),
                  avg(fBodyAccJerkmeanZ),
                  avg(fBodyGyromeanX),
                  avg(fBodyGyromeanY),
                  avg(fBodyGyromeanZ),
                  avg(fBodyAccMagmean),
                  avg(fBodyBodyAccJerkMagmean),
                  avg(fBodyBodyGyroMagmean),
                  avg(fBodyBodyGyroJerkMagmean)
                  from TidyDataSet
                  group by Subject, ActivityDescription")
## Create a file with the new tidy dataset
write.table(IndependentDataSet,"TidyDataSet.txt",row.names = FALSE)


