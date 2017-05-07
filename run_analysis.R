library(dplyr)
library(reshape2)
## Create data dir to download and unzip all files
if(!file.exists("./data")){dir.create("./data")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
temp <- tempfile()
download.file(fileurl, temp, method = "curl")
unzip(temp, exdir = "./data/")

##import data into R
##import labels and features 
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels) <- c("y", "activity")
features <- read.table("./data/UCI HAR Dataset/features.txt")

##import training and testing data
##training dataset 
x_train <- tbl_df(read.table("./data/UCI HAR Dataset/train/X_train.txt"))
y_train <- as.integer(read.table("./data/UCI HAR Dataset/train/y_train.txt")[, 1])
subject_train <- as.integer(read.table("./data/UCI HAR Dataset/train/subject_train.txt")[, 1])

##testing dataset
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- as.integer(read.table("./data/UCI HAR Dataset/test/y_test.txt")[, 1])
subject_test <- as.integer(read.table("./data/UCI HAR Dataset/test/subject_test.txt")[, 1])

##assign column names and adding rows to complete trainnig and testing dataset
names <- as.character(features[, 2])
colnames(x_train) <- colnames(x_test) <- make.unique(names)

train <- x_train %>% cbind(subject_train, y_train) %>% 
    merge(activity_labels, by.x = "y_train", by.y = "y") %>%
    select(subject = subject_train, activity, contains("mean"), contains("std")) %>%
    mutate(dataset = "train")
    
test <- x_test %>% cbind(subject_test, y_test) %>% 
    merge(activity_labels, by.x = "y_test", by.y = "y") %>%
    select(subject = subject_test, activity, contains("mean"), contains("std")) %>%
    mutate(dataset = "test")
##create final data with both training and test data
dataset <- rbind(train, test)

##getting clean dataset of mean of each variables by subject and activities
tidy_data <- dataset %>% group_by(subject, activity) %>% 
    summarise_each(funs(mean), -dataset) %>%
    melt(id.vars = c("subject","activity"), measure.vars = 3:88, value.name = "mean_value")

##write tidy_data into file
write.table(tidy_data, file = "./data/tidy_data.txt", row.names = FALSE)

