## Set working directory to where data was unzipped

setwd("C:/Users/cpeltz1/Desktop/Coursera/GettingandCleaningData/Week3/UCI HAR Dataset")

## Load necessary library

library(plyr)

## Merge the training and test sets to create one data set

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

x_data <- rbind(x_train, x_test)

y_data <- rbind(y_train, y_test)

subject_data <- rbind(subject_train, subject_test)

## Extract only the measurements on the mean and standard deviation for each measurement

features <- read.table("features.txt")

mean_and_std <- grep("-(mean|std)\\(\\)", features[, 2])

x_data <- x_data[, mean_and_std]

# correct the column names
names(x_data) <- features[mean_and_std, 2]

## Use descriptive activity names to name the activities in the data set

activities <- read.table("activity_labels.txt")

y_data[, 1] <- activities[y_data[, 1], 2]

names(y_data) <- "activity"

## Appropriately label the data set with descriptive variable names

names(subject_data) <- "subject"

all_data <- cbind(x_data, y_data, subject_data)

colNames  = colnames(all_data); 

for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

## Reassigning the new descriptive column names to the finalData set
colnames(all_data) = colNames;

## Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

# 66 <- 68 columns but last two (activity & subject)
tidy_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
