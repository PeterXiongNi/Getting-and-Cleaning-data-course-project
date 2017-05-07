Getting-and-Cleaning-data-course-project
===============
run_analysis.R script download data into(create if not exists) ./data folder in your working directory, reads all necessary files into R and transform them into a tidy data set and writes into "./data/tidy_data.txt"
# Source Data
* script reads "./data/UCI HAR Dataset/activity_labels.txt" and "./data/UCI HAR Dataset/features.txt" into dataframe for column and rows names to be used later.
* script reads "./data/UCI HAR Dataset/train/X_train.txt", "./data/UCI HAR Dataset/train/y_train.txt", "./data/UCI HAR Dataset/train/subject_train.txt" for both training and testing dataset as raw data to process
# Transformation
1. column names are added to training and testing data by adding features table
2. subject and activity are column binded into train and test data, activity is retrived by joining with activity_labels table.
3. extracts only the measurements on the mean and standard deviation for each measurement.
4. merges test and train data, groups by subject and activity and summarize all with mean value
5. create lean tidy dataset tidy_data by melt table with id = subject and activity and measures = all variables
# Saving data
clean dataset tidy_data is then written into "./data/tidy_data.txt" under your working directory
