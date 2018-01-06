
if(!file.exists("./data")) {
        dir.create("./data")
}

zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(zipUrl, destfile = "./data/dataset.zip", method = "curl")
unzip("./data/dataset.zip", exdir = "./data")

install.packages("data.table")
library(data.table)

install.packages("plyr")
library(plyr)

install.packages("dplyr")
library(dplyr)

features <- read.table("./data/UCI HAR Dataset/features.txt")
head(features)
tail(features)

subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
head(subject_train)
tail(subject_train)

X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
head(X_train)
tail(X_train)

Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
head(Y_train)
tail(Y_train)

subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
head(subject_test)
tail(subject_test)

X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
head(X_test)

Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
head(Y_test)
tail(Y_test)

trainData <- cbind(subject_train, Y_train, X_train)

testData <- cbind(subject_test, Y_test, X_test)

traintestData <- rbind(trainData, testData)

colnames(traintestData)[1] <- "subject-id"

colnames(traintestData)[2] <- "activity-name"

traintestData2 <- setnames(traintestData, old = names(traintestData[3:563]), new = as.character(features[1:561, 2]))

names(traintestData2)
head(features)
tail(features)

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

traintestData2$`activity-name` <- activity_labels$V2[match(traintestData2$`activity-name`, activity_labels$V1)]

head(traintestData2[, 2])
tail(traintestData2[, 2])

meanstdData <- cbind(traintestData2$`subject-id`,
                     traintestData2$`activity-name`,
                     traintestData2[(grep("mean|std", colnames(traintestData2)))])

names(meanstdData)

meanstdData$"traintestData2$`activity-name`" <- tolower(meanstdData$"traintestData2$`activity-name`")
meanstdData$"traintestData2$`activity-name`" <- sub("_d", "D", meanstdData$"traintestData2$`activity-name`")
meanstdData$"traintestData2$`activity-name`" <- sub("_u", "U", meanstdData$"traintestData2$`activity-name`")

colnames(meanstdData)[1] <- "subjectId"
colnames(meanstdData)[2] <- "activityName"

colnames(meanstdData) <- gsub("-", "", colnames(meanstdData))

names(meanstdData)

colnames(meanstdData) <- sub("()", "", colnames(meanstdData), fixed = TRUE)

names(meanstdData)

colnames(meanstdData) <- sub("^t", "time", colnames(meanstdData))

colnames(meanstdData) <- sub("^f", "freq", colnames(meanstdData))

names(meanstdData)

groupSubjActData <- meanstdData %>% group_by(subjectId, activityName) %>% summarise_all(funs(mean))

head(groupSubjActData)
tail(groupSubjActData)

write.table(groupSubjActData, file = "./data/tidy_data_set.txt", row.names = FALSE)
