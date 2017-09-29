# Getting and Cleaning Data Week 4 Project

The project is conducted as described in following steps:

Step 1: Download the zip file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, unzip it to the current working directory, and then remove the zip file 

Step 2: Read in following files using read.table: features.txt, y_test.txt, subject_test.txt, y_train.txt and subject_train.txt into corresponding R objects. X_test.txt and X_train.txt are read in by readLines function. For each line read in, the leading white spaces are removed and the separators of two or more white spaces are converted into separators of one white space, and the resulting line is then split based on the single white spaces. Finally, the generated R objects corresponding to X_test.txt and X_train.txt are converted into data.frames  

Step 3: Convert all data.frame objects into tibble objects so that they can be manipulated easily with dlpyr functions

Step 4: Conduct Task 1. Merge train dataset and test dataset into one dataset, full.dataset. Specifically, X.train and X.test. y.train and y.test, subject.train and subject.test are merged, respectively, with bind_rows function to form three data.frames: X.all, y.all and subject.all, which are then combined together by bind_cols to form full.dataset. The column names of y.all and subject.all are labeled with "Activity" and "Subject", respectively. The columns of X.all are named with feature names found in features.txt

Step 5: Conduct Task 2: Columns containing "mean" or "std" along with columns Subject and Activity are selected using select function to form a new dataset, mean_std.dataset, which contains 79 measurement columns plus columns Subject and Activity. 

Step 6: Conduct Task 3: First read in activity labels. Then use activity labels to replace the acitivity codes in column Activity.  

Step 7: Conduct Task 4: The names of Columns Subject and Activity are set in Task 1 and kept the same. The other column names of mean_std.dataset are modified by replacing "-" with "_" and removal of "()". The reason for making these changes is that "-" and "()" are not components of valid variable names and may cause some function calls to fail. 

Step 8: Conduct Task 5: First, the mean_std.dataset is manipulated with group_by function before being submitted to summarize_all function to calculate the average of each variable for each activity and each subject. The summarize_all function generates a data.frame of new tidy dataset. Second, the columns except Subject and Activity of the resulting dataset are renamed by suffixing them with "_avg". Finally, the new dataset is written to a text file called averageValues.txt by write.table.
