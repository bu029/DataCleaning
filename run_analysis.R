# Merge the training and test datasets

# Read files

# Read training datasets
x_train <- read.table("C:/Users/HP-i5/Desktop/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/HP-i5/Desktop/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/HP-i5/Desktop/UCI HAR Dataset/train/subject_train.txt")

#  Read test datasets
x_test <- read.table("C:/Users/HP-i5/Desktop/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/HP-i5/Desktop/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/HP-i5/Desktop/UCI HAR Dataset/test/subject_test.txt")

#  Read feature vector
features <- read.table("C:/Users/HP-i5/Desktop/UCI HAR Dataset/features.txt")

# Read activity labels
activityLabels = read.table("C:/Users/HP-i5/Desktop/UCI HAR Dataset/activity_labels.txt")

# Assign variable names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activityLabels) <- c("activityID", "activityType")

# Merging all datasets into one set
alltrain <- cbind(y_train, subject_train, x_train)
alltest <- cbind(y_test, subject_test, x_test)
finaldataset <- rbind(alltrain, alltest)

# Extract only the measurements on the mean and sd for each measurement

# Read column names
colNames <- colnames(finaldataset)

# Create vector for defining ID, mean, and sd
mean_and_std <- (grepl("activityID", colNames) |
                   grepl("subjectID", colNames) |
                   # THIS WAS COPIED FROM https://github.com/wdluft/getting-and-cleaning-data-week-4-project
                   # SHOULD NOT BE ACCEPTED AS A NEW SUBMISSION
                   grepl("mean..", colNames) |
                   grepl("std...", colNames)
)

#  Making nessesary subset
setforMeanandStd <- finaldataset[ , mean_and_std == TRUE]

# Use descriptive activity names
setWithActivityNames <- merge(setforMeanandStd, activityLabels,
                              by = "activityID",
                              all.x = TRUE)

#Label data set with the descriptive variable names


#Creating a second,  independent tidy data set with the avg of each variable for each activity and subject

# Making a second tidy data set
tidySet <- aggregate(. ~subjectID + activityID, setWithActivityNames, mean)
tidySet <- tidySet[order(tidySet$subjectID, tidySet$activityID), ]

#Writing second tidy data set into a txt file
write.table(tidySet, "C:/Users/HP-i5/Desktop/peer/DataCleaning/tidySet.txt", row.names = FALSE)