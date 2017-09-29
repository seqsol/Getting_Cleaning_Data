# Download the dataset file from the source, unzip it and them delete the zip file
url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "dataset.zip")
unzip("dataset.zip")
unlink("dataset.zip")

# Read in text files into R objects
features<- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
y.test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt")
y.train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt")

#read in X_test.txt, remove the leading white spaces, change the separators of two or more white spaces to separators of one white space, and then split the string on the white spaces 
X.test <- strsplit(gsub("  +", " ", gsub("^ +", "", readLines("UCI HAR Dataset/test/X_test.txt"))), " ")
#Convert the list X.test into data.frame X.test
X.test<-data.frame(matrix(unlist(X.test), ncol=nrow(features)), stringsAsFactors = FALSE)

## Read in data of train.txt and conduct the same string processing as for test.txt above
X.train <- strsplit(gsub("  +", " ", gsub("^ +", "", readLines("UCI HAR Dataset/train/X_train.txt"))), " ")
X.train<-data.frame(matrix(unlist(X.train), ncol=nrow(features)), stringsAsFactors = FALSE)

library(tibble)
library(dplyr)
#library(tidyr)
#library(readr)
features <- as_tibble(features)
y.test <- as.tibble(y.test)
subject.test <- as.tibble(subject.test)
X.test <- as.tibble(X.test)
y.train <- as.tibble(y.train)
subject.train <- as.tibble(subject.train)
X.train <- as.tibble(X.train)


# Task 1: Merge test dataset and train dataset, name the columns of merged dataset with features
X.all <- bind_rows(X.train, X.test)
X.all <- data.frame(lapply(X.all, as.numeric))
names(X.all) <- features$V2
y.all <- bind_rows(y.train, y.test)
names(y.all) <- "Activity"
subject.all <- bind_rows(subject.train, subject.test)
names(subject.all) <-"Subject"
#Add Subject column from subject.all and Activity column from y.all to the X.all to form full.dataset
full.dataset<- bind_cols(subject.all, y.all, X.all)

# Task 2: Extract only the measurements on the mean and standard deviation for each measurement
mean_std.dataset <- select(full.dataset, Subject, Activity, grep("mean|std", names(full.dataset), value=TRUE))

# Task 3: Uses descriptive activity names to name the activities in the data set
activity <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)$V2
for (i in 1:length(activity)){
    mean_std.dataset$Activity[which(mean_std.dataset$Activity == i)] = activity[i]
}

# Task 4: Appropriately labels the data set with descriptive variable names
# As done in Task 1, the column corresponding to subjects is labeled as Subject; the column containing data from y_train and y_test is labeled as Activity. The names of all other columns, which are assigned in Task 1, are modified by replacing "-" with "_" and removal of "()"    

names(mean_std.dataset) = gsub("-", "_", names(mean_std.dataset)) %>% gsub("\\(\\)", "",.)

# Task 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# Use summarize_all to calculate the averages and generate a data.frame of new tidy dataset
new.dataset <- mean_std.dataset %>%
    group_by(Activity, Subject) %>%
    summarize_all(funs(mean))

# Add suffix of "_avg" to all column names except columns Subject and Activity 
names(new.dataset)[-c(1,2)] = paste(names(new.dataset)[-c(1,2)], "_avg", sep="")

# Generate a txt file for the new.dataset 
write.table(new.dataset, file="averageValues.txt", row.names = FALSE)





