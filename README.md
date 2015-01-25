# GCDProject
Getting and Cleaning Data Course Course Project

The analysis is performed by the script 'run_analysis.R'. You can run it like this from inside R:
`
source("run_analysis.R")
`


First the script will download the UCI HAR Datasetif it is not in the directory already, then unzip it.

The script will read in the training and test datasets together with the labels for activities and IDs for the subjects. It will add variables (columns) to the datasets with the activities and IDs. Then the script will merge both training and test datasets and add descriptive variable names from the 'UCI HAR Dataset/features.txt' file.

Furthermore, the script will select only those variables which contain 'mean()' or 'std()' in their name. Then it will aggregate the data, calculating the mean of each variable for each activity and each subject.

The resulting tidy dataset is written out to the text file 'tidy_dataset.txt' in the csv format.