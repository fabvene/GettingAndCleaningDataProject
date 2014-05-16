##======================================================
## Step 1:
## Merge the training and the test sets to create
## one data set.
##========================================================

#Read Train and Test
X_train<-read.table("train\\X_train.txt", header=FALSE)
X_test<-read.table("test\\X_test.txt", header=FALSE)

#Merge them together
Data<-rbind(X_train, X_test)

#Read Activity (train and test)
y_test<-read.table ("test\\y_test.txt", header=FALSE)
y_train<-read.table ("train\\y_train.txt", header=FALSE)

#Merge activities
Act <- rbind(y_test, y_train)

#Read Subject (train and test)
Subj_test<- read.table("test\\subject_test.txt", header=FALSE)
Subj_train<- read.table("train\\subject_train.txt", header=FALSE)

#Merge subjects
Subjects <- rbind(Subj_test, Subj_train)



##======================================================
## Step 2:
## Extracts only the measurements on the mean and
## standard deviation for each measurement.
##======================================================


#Read Features in table, select only "mean" and "standard" and filter the data accordingly
featuresID <- read.table("features.txt", header=FALSE)
meanAndStd <- subset(featuresID,grepl("mean|std", featuresID[ ,2]))

meanAndStdData <- Data[,meanAndStd[ ,1] ]


AllData <- cbind(meanAndStdData, Act, Subjects)

##======================================================
## Part 3:
## Uses descriptive activity names to name the activities in the data set
##======================================================

#Read activity labels, create vector with labels and rename the appropriate column in the main data frame ("AllData").
activity_labels <- read.table ("activity_labels.txt", header=FALSE)

AllDataLabels <- factor(AllData[, 80], levels = activity_labels[,1], labels = activity_labels[,2])

AllData[, 80]<-AllDataLabels 

##======================================================
## Part 4:
## Appropriately labels the data set with descriptive activity names.
## Assumption: Descriptive names = descriptive column names.
##======================================================

names(AllData) <- c(as.character(meanAndStd[,2]),"Activity", "Subject")

##======================================================
## Part 5:
## Creates a second, independent tidy data set with the average of each
## variable for each activity and each subject.
##======================================================


library(reshape2)

#reshape the data and create a new dataframe
AllDataMelt<-melt(AllData,id=c("Activity","Subject"))
AllDataFinal<-dcast(AllDataMelt,Activity+Subject~variable,mean)

#Output to files
write.table(AllData,file="AllDataMerged.txt",sep=" ",append=FALSE)
write.table(AllDataFinal,file="AllDataTidy.txt",sep=" ",append=FALSE)
