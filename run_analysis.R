
# download sample, unless it is there already
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "UCI HAR Dataset.zip"
if(!file.exists(fileName)){
  download.file(fileUrl, destfile = fileName, method = "curl")
}

# unzip sample
unzip(fileName)
#list.files("UCI HAR Dataset/")

# activites
Activity_names = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")

# You should create one R script called run_analysis.R that does the following. 
# 1- Merges the training and the test sets to create one data set.

# training data, activities, subjects
X_train <-  read.table("UCI HAR Dataset/train/X_train.txt") # training data
y_train <- (read.table("UCI HAR Dataset/train/y_train.txt"))[,1] # training activities
s_train <- (read.table("UCI HAR Dataset/train/subject_train.txt"))[,1] # subject id
y_train <- Activity_names[y_train] # translate to activity names
X_train$Activity <- y_train
X_train$Subject  <- s_train

# test data, activities, subjects
X_test <-  read.table("UCI HAR Dataset/test/X_test.txt") # testing data
y_test <- (read.table("UCI HAR Dataset/test/y_test.txt"))[,1] # testing activities
s_test <- (read.table("UCI HAR Dataset/test/subject_test.txt"))[,1] # subject id
y_test <- Activity_names[y_test] # translate to activity names
X_test$Activity <- y_test
X_test$Subject  <- s_test

# merged data
X_all <- merge(X_train, X_test, all = T)

# 2- Extracts only the measurements on the mean and standard deviation for each measurement.
# read feature names from file and add 'Activities' since we added above in the data frames
features <- read.table("UCI HAR Dataset/features.txt", colClasses = "character")
feature_names <- c(features[,2],'Activity','Subject')
names(X_all) <- feature_names
selected_indices <- grep("-mean\\(\\)|-std\\(\\)|Activity|Subject", feature_names)
selected_features <- feature_names[selected_indices]
X_selected <- X_all[selected_features]

# 3- Uses descriptive activity names to name the activities in the data set
# see above, Acitivity_names

# 4- Appropriately labels the data set with descriptive variable names. 
# see above, feature names

# 5- From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.

# use aggregate
X_aggregated <-aggregate(X_selected[,1:68], by=list(X_selected$Activity, X_selected$Subject),
                    FUN=mean, na.rm=TRUE)[,1:68]

# just a couple of cross checks
#mean(X_selected[X_selected$Activity == "LAYING" & X_selected$Subject == 1,][,'tBodyAcc-mean()-X'])
#mean(X_selected[X_selected$Activity == "LAYING" & X_selected$Subject == 1,][,'fBodyBodyGyroJerkMag-std()'])
# rename the groups  
names(X_aggregated)[1] <- 'Activity'
names(X_aggregated)[2] <- 'Subject'

# write out to file
write.table(X_aggregated, file = "tidy_dataset.txt", sep=",", row.name=FALSE)
