### loading  data.table package
library(data.table)
### load data from files.
activity_labels<- read.table ("activity_labels.txt")
features <- read.table('features.txt')

X_train <- read.table ("train/X_train.txt")
y_train <- read.table ("train/y_train.txt")
subj_train <- read.table ("train/subject_train.txt")
X_test <- read.table ("test/X_test.txt")
y_test <- read.table ("test/y_test.txt")
subj_test <- read.table ("test/subject_test.txt")

#merging   test and train
X_data<-rbind(X_test,X_train)
y_data<-rbind(y_test,y_train)
subj_data <- rbind(subj_test,subj_train)

# merging labels and data
data <-cbind(y_data,subj_data)
data <-cbind(data,X_data)
# adding colnames to dataset
names(data)<-c("activity","subject",as.vector(features$V2))
# adding factor of meaninful activity lables to dataset
data$activity <- factor(data$activity, labels = as.vector(activity_labels$V2))
# creating clear dataset with std,mean of activity like columnts
cldata<-data[,grepl("std|mean|activity|subject",names(data))]

# extracting  data for p.5  for  independent tidy data set 
# with the average of each variable for each activity and each subject.
# need to use converd dataframe to data table to be able to use by aggregation.
data_table <-data.table(cldata)
tidydataset <- data_table[, lapply(.SD, mean), by = c("activity","subject")] 
#tidydataset <- data.frame(do.call("rbind",by(cldata[,-1],cldata$activity,colMeans)))

#saving tidy dataset to txt file
write.table(tidydataset, file='tidydataset.txt', row.names=F)