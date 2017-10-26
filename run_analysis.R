library(dplyr)

# Step 1
# Merge the training and test sets to create one data set
###############################################################################

#x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x_train <- read.csv("./UCI HAR Dataset/train/X_train.txt")

#y_train <- read.table("./UCI HAR Datasettrain/y_train.txt")
y_train <- read.csv("./UCI HAR Dataset/train/y_train.txt")
#subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt")

#x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
x_test <- read.csv("./UCI HAR Dataset/test/X_test.txt")

#y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt")
#subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt")

# create 'x' data set
#x_data <- rbind(x_train, x_test)
x_data <- merge(x_train, x_test,all = TRUE)


# create 'y' data set
#y_data <- rbind(y_train, y_test)
y_data <- merge(y_train, y_test, all = TRUE )

# create 'subject' data set
#subject_data <- rbind(subject_train, subject_test)
subject_data <- merge(subject_train, subject_test, all = TRUE)


# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

#features <- read.table("features.txt")
features <- read.csv("./UCI HAR Dataset/features.txt")

# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

#activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
activities <- read.csv("./UCI HAR Dataset/activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
#all_data <- cbind(x_data, y_data, subject_data)
all_data <- merge(x_data, y_data, subject_data, all = TRUE)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)