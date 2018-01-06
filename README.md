# Getting and Cleaning Data Course Project #

The following text explains the steps that were completed, following the Course Project requirements, i.e. the instructions - steps 1 to 5.

## "1. Merges the training and the test sets to create one data set." ##

Create the appropriate folder to store all the files.

`if(!file.exists("./data")) {dir.create("./data")}`

Download the .zip file in the newly created directory and unzip.

`zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"`
`download.file(zipUrl, destfile = "./data/dataset.zip", method = "curl")`
`unzip("./data/dataset.zip", exdir = "./data")`

Install the packages that most probably will be used to further manipulate the data sets.

`install.packages("data.table")`
`library(data.table)`

`install.packages("plyr")`
`library(plyr)`

`install.packages("dplyr")`
`library(dplyr)`

Read features.txt into R to get a closer look on the data and the possible variables.

`features <- read.table("./data/UCI HAR Dataset/features.txt")`
`head(features)`
`tail(features)`

Read all train data files separately to get a feeling of the different data and figure out how to properly combine them all together for one complete train data set.

`subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")`
`head(subject_train)`
`tail(subject_train)`

`X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")`
`head(X_train)`
`tail(X_train)`

`Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")`
`head(Y_train)`
`tail(Y_train)`

Read all test data files separately to get a feeling of the different data and figure out how to properly combine them all together for one complete test data set.

`subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")`
`head(subject_test)`
`tail(subject_test)`

`X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")`
`head(X_test)`

`Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")`
`head(Y_test)`
`tail(Y_test)`

Merge the train data sets.

`trainData <- cbind(subject_train, Y_train, X_train)`

Merge the test data sets.

`testData <- cbind(subject_test, Y_test, X_test)`

Merge the train and test data sets.

`traintestData <- rbind(trainData, testData)`

Before we get into Question 2 from the Assignment, we need to clead the data set, i.e. make it tidy.

Rename the columns, as per the information in the additional text files.

The first column/variable in the new data set (that we took from the subject_train/test.txt files) is the "subject_id".

`colnames(traintestData)[1] <- "subject-id"`

The second column/variable in the new data set (that we took from the Y_train/test.txt files) is the "activity_name".

`colnames(traintestData)[2] <- "activity-name"`

The following 561 variables - V1:V561 (from the X_train/test.txt files) correspond to the variable names listed in the the features.txt file.

`traintestData2 <- setnames(traintestData, old = names(traintestData[3:563]), new = as.character(features[1:561, 2]))`

Check if the names of the variables have been applied correctly and in the correct order.

`names(traintestData2)`
`head(features)`
`tail(features)`

Once we have the names of all variables set, we apply the corresponding activity in the "activity-name" variable, depending on the assigned code (from 1 to 6 in the activity_labels.txt file), for even tidier data set.

Read activity_labels.txt into R to get a closer look on the data.

`activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")`

Assign the appropriate activity name to the corresponding code observation in the "activity-name" variable.

``traintestData2$`activity-name` <- activity_labels$V2[match(traintestData2$`activity-name`, activity_labels$V1)]``

`head(traintestData2[, 2])`
`tail(traintestData2[, 2])`

## "2. Extracts only the measurements on the mean and standard deviation for each measurement." ##

`install.packages("dplyr")`
`library(dplyr)`

``meanstdData <- cbind(traintestData2$`subject-id`, traintestData2$`activity-name`, traintestData2[(grep("mean|std", colnames(traintestData2)))])``

Check if all variables have the strings "mean" and "std" in them; check if the subject-id and the activity-name variables are there too (clean names in Step 4).

`names(meanstdData)`

## "3. Uses descriptive activity names to name the activities in the data set" ##

Note: This step was completed as the last activity in Step 1, while tiding the data set; there is no need to run the following two lines of code again:

`activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")`
``traintestData2$`activity-name` <- activity_labels$V2[match(traintestData2$`activity-name`, activity_labels$V1)]``

Clean the acitivy names from all capital letters, spaces, and "_" for tidier look of the data set.

``meanstdData$"traintestData2$`activity-name`" <- tolower(meanstdData$"traintestData2$`activity-name`")``
``meanstdData$"traintestData2$`activity-name`" <- sub("_d", "D", meanstdData$"traintestData2$`activity-name`")``
``meanstdData$"traintestData2$`activity-name`" <- sub("_u", "U", meanstdData$"traintestData2$`activity-name`")``

## "4. Appropriately labels the data set with descriptive variable names." ##

The renaming of the variables with the observations from the features.txt file was completed in Step 1, in order to identify the the variables with "mean" and "std" in Step 2.

Now it's time to remove the untidy symbols from the names of the variables; these are symbols such as ".", "-", and "()".

Assign appropriate/clean variable names to the first two variables. It's faster to assign, i.e. the code is shorter since we are removing "leftovers" from working with the data set earlier.

`colnames(meanstdData)[1] <- "subjectId"`
`colnames(meanstdData)[2] <- "activityName"`

Remove "-" in the variable names, including repetition of "-" in a single variable name, with gsub().

`colnames(meanstdData) <- gsub("-", "", colnames(meanstdData))`

`names(meanstdData)`

Remove "()" in the variable names.

`colnames(meanstdData) <- sub("()", "", colnames(meanstdData), fixed = TRUE)`

`names(meanstdData)`

Lastly, replace "t" and "f" in the beginning of the variable name (thus ^) with "time" and "freq" respectively.

`colnames(meanstdData) <- sub("^t", "time", colnames(meanstdData))`
`colnames(meanstdData) <- sub("^f", "freq", colnames(meanstdData))`

`names(meanstdData)`

## "5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject." ##

`groupSubjActData <- meanstdData %>% group_by(subjectId, activityName) %>% summarise_all(funs(mean))`

`head(groupSubjActData)`
`tail(groupSubjActData)`

### Get the data set ready for submission/upload, as instructed in the "My submission" section in Coursera, in .txt format. ###

`write.table(groupSubjActData, file = "./data/tidy_data_set.txt", row.names = FALSE)`

End of the assignment steps.