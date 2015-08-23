library(data.table)
library(plyr)

# location of data files
# assumes your data is in a folder called "UCI HAR Dataset" at the same level as the folder containg your R script
location_data <- ".\\UCI HAR Dataset"

# Read in the data
# Subject Files
subject_test <- read.table("test/subject_test.txt")
subject_train <- read.table("train/subject_train.txt")

# Activity files
activity_test <- read.table("test/X_test.txt")
activity_train <- read.table("train/X_train.txt")

# data files
label_test <- read.table("test/y_test.txt")
label_train <- read.table("train/y_train.txt")

# Combine the data
s <- rbind(subject_test, subject_train)
x <- rbind(activity_test, activity_train)
y <- rbind(label_test, label_train)

# read feature list, to be used for column names
features_list <- read.table("features.txt", stringsAsFactors=FALSE)
features <- featuresList$V2

# pattern match the desired columns
## restrict dataset and make the names more readable
desired_columns <- grepl("(std|mean[^F])", features, perl=TRUE)
x <- x[, desired_columns]
names(x) <- features[desired_columns]
names(x) <- tolower(names(x))

# Get activities and assign to data set for more readable names
activities <- read.table("activity_labels.txt")
y[,1] = activities[y[,1], 2]
names(y) <- "activity" 

# name subject column
names(s) <- "subject"

# write data set
tidy_data <- cbind(s, y, x)
write.table(tidy_data, "TidyData.txt", row.name=FALSE)

# create summary data set
ff <- ddply(tidy_data, .(subject, activity), .fun=function(x){ colMeans(x[,-c(1:2)]) })
colnames(ff)[-c(1:2)] <- paste(colnames(ff)[-c(1:2)], "_mean", sep="")

# write second data set
write.table(ff, "TidyDataSummary.txt", row.name=FALSE)
