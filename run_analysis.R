##You should create one R script called run_analysis.R that does the following. 
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names. 
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

require("data.table")
require("reshape2")

# loading training data
subject_train <- read.table(file = "./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table(file = "./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table(file = "./UCI HAR Dataset/train/y_train.txt")

# loading test data
subject_test <- read.table(file = "./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table(file = "./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table(file = "./UCI HAR Dataset/test/y_test.txt")

#loading features & activity labels
features <- read.table(file = "./UCI HAR Dataset/features.txt")
activity_labels <- read.table(file = "./UCI HAR Dataset/activity_labels.txt")

#Appropriately labels the data set with descriptive variable names
names(x_test) <- features$V2
names(x_train) <- features$V2

#column index for features to be extracted (first two column )
featuesToExtract <- grep(".*[Mm]ean.*|.*[Ss]td.*", features$V2) 
x_test<-subset(x_test,select=featuesToExtract)
x_train<-subset(x_train,select=featuesToExtract)

#Uses descriptive activity names to name the activities in the data set
y_train_labels <- merge(y_train,activity_labels,by="V1")
y_test_labels <- merge(y_test,activity_labels,by="V1")

#Merges the training and the test sets to create one data set.
test<-cbind(subject_test,y_test_labels,x_test)
train<-cbind(subject_train,y_train_labels,x_train)
data<-rbind(test,train)

#Appropriately labels the data set with descriptive variable names
names(data)[1] <- "subject"
names(data)[2] <- "activity"
names(data)[3] <- "activity_labels"

#independent tidy data set with the average of each variable for each activity and each subject
tidy_melted<-melt(data,id=c("subject","activity"),measure.vars = names(data)[c(4:89)])
tidy<-dcast(tidy_melted,subject+activity~variable,mean)

#write data to txt file
write.table(tidy,file="tidy.txt",row.names = FALSE)
