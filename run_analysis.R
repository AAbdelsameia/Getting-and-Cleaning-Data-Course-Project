## loading the neccessary libraries

library(dplyr)
library(reshape)
library(reshape2)
library(data.table)
library(tidyr)


## downloaing the Data

data_zip_file <- "Coursera_DS3_Final.zip"

if (!file.exists(data_zip_file)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, data_zip_file, method="curl")
} 

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


## reading the features and teh activity from the dataset and extracting the mean and std files

features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
mean_std_features <- grepl("mean|std", features[,2])


## loading the X_test data and extracting the needed mean and std.

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(X_test) <- features[,2]
X_test <- X_test[,mean_std_features]


## loading the y_test

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_test[,2] = activity_labels[,2][y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")


## loading the subject_test and updating the names

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(subject_test) = "subject"


## column binding 

test_data <- cbind(subject_test, y_test, X_test)


## loading the X_train data and extracting the needed mean and std.

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
names(X_train) = features[,2]
X_train <- X_train[,mean_std_features]


## oading the y_train

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_train[,2] = activity_labels[,2][y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")


## loading the subject_train
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(subject_train) = "subject"


## column binding
train_data <- cbind(subject_train, y_train, X_train)


## merging the trainign and the test data sets 

merged_data = rbind(test_data, train_data)


## creating the tidy_data file using melt and dcast 

melted_data <- melt(merged_data, id = c("subject", "Activity_ID", "Activity_Label"))
tidy_data <- dcast(melted_data, subject + Activity_Label + Activity_ID  ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt")

