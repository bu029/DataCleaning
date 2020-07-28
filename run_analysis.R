unzip(zipfile="C:/Users/HP-i5/Downloads/getdata.zip",exdir="C:/Users/HP-i5/Documents/UCI HAR Dataset")

list.files("C:/Users/HP-i5/Documents/UCI HAR Dataset")

pathdata = file.path("C:/Users/HP-i5/Documents/UCI HAR Dataset", "UCI HAR Dataset")
files = list.files(pathdata, recursive=TRUE)
files
FeaturesTrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ActivityTrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
SubjectTrain = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
#Reading the testing tables
FeaturesTest= read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ActivityTest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
SubjectTest = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
#Read the features data
FeaturesNames= read.table(file.path(pathdata, "features.txt"),header = FALSE)
#Read activity labels data
ActivityLabels= read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#####Merg dataframes: Features Test&Train,Activity Test&Train, Subject Test&Train
FeaturesData <- rbind(FeaturesTest, FeaturesTrain)
SubjectData <- rbind(SubjectTest, SubjectTrain)
ActivityData <- rbind(ActivityTest, ActivityTrain)

####Renaming colums in ActivityData & ActivityLabels dataframes
names(ActivityData) <- "ActivityN"
names(ActivityLabels) <- c("ActivityN", "Activity")

####Get factor of Activity names
Activity <- left_join(ActivityData, ActivityLabels, "ActivityN")[, 2]

####Rename SubjectData columns
names(SubjectData) <- "Subject"
#Rename FeaturesData columns using columns from FeaturesNames
names(FeaturesData) <- FeaturesNames$V2

###Create one large Dataset with only these variables: SubjectData,  Activity,  FeaturesData
DataSet <- cbind(SubjectData, Activity)
DataSet <- cbind(DataSet, FeaturesData)

###Create New datasets by extracting only the measurements on the mean and standard deviation for each measurement
subFeaturesNames <- FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
DataNames <- c("Subject", "Activity", as.character(subFeaturesNames))
DataSet <- subset(DataSet, select=DataNames)

#####Rename the columns of the large dataset using more descriptive activity names
names(DataSet)<-gsub("^t", "time", names(DataSet))
names(DataSet)<-gsub("^f", "frequency", names(DataSet))
names(DataSet)<-gsub("Acc", "Accelerometer", names(DataSet))
names(DataSet)<-gsub("Gyro", "Gyroscope", names(DataSet))
names(DataSet)<-gsub("Mag", "Magnitude", names(DataSet))
names(DataSet)<-gsub("BodyBody", "Body", names(DataSet))

####Create a second, independent tidy data set with the average of each variable for each activity and each subject
SecondDataSet<-aggregate(. ~Subject + Activity, DataSet, mean)
SecondDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Activity),]

#Save this tidy dataset to local file
write.table(SecondDataSet, file = "C:/Users/HP-i5/Desktop/tiddata.txt",row.name=FALSE)