# path where we expect to find the data files:
data_path <- "UCI HAR Dataset"


# From the features dataset we should only keep the mean and std variables
# SO we need the feature names first:
fnames <- read.table(paste0(data_path,"/","features.txt"), sep = "", colClasses = "character")

# we keep only the second col for the feature names:
fnames <- fnames[,2]

# list the indices of the feature names containing "mean()" or "std()"
keptFeatures <- grep("mean\\(\\)|std\\(\\)",fnames)
print(paste("Keeping",length(keptFeatures),"features"))


# Read the names we want for the labels factor:
lnames <- read.table(paste0(data_path,"/","activity_labels.txt"), sep = "", colClasses = "character")

# Keep only the second col:
lnames <- lnames[,2]

# helper method used to build a dataset from the separated data files:
# this will load the "subject", "X" and "y" specific files for a given 
# data set type ("train" or "test") and concatenate all the entries of
# interest in a single dataset
# tname should be either "train" or "test"
build_dataset_part <- function(tname)
{
  # prepare the sub path where to find the data:
  sub_path <- paste0(data_path,"/",tname)
  
  print(paste("Loading data from path:",sub_path))
  
  # load the subject data set:
  subject <- read.table(paste0(sub_path,"/","subject_",tname,".txt"), sep = "", colClasses = "numeric")
  names(subject) <- c("subject")
  
  # load the feature data set:
  # Note that sep = "" refers to multi space separator
  features <- read.table(paste0(sub_path,"/","X_",tname,".txt"), sep = "", colClasses = "numeric")
  
  # load the labels:
  labels <- read.table(paste0(sub_path,"/","y_",tname,".txt"), sep = "", colClasses = "numeric")
  names(labels) <- c("activity")

  # replace the labels with a factor:
  labels[,1] <- as.factor(labels[,1])
  
  # use the proper names for the labels:
  levels(labels[,1]) <- lnames
  
  # assign the feature names:
  names(features) <- fnames
  
  # keep only the features of interest:
  features <- features[,keptFeatures]
  
  # concatenate the datasets:
  dataset <- cbind(subject,labels,features)
  
  # return the generated dataset:
  dataset
}


train_set <- build_dataset_part("train")

test_set <- build_dataset_part("test")

# concatenate both data sets:
data_set <- rbind(train_set,test_set)

# rename the variables appriately:
vnames <- names(data_set)
vnames <- sub("-mean\\(\\)-?([X-Z])?","Mean\\1",vnames)
vnames <- sub("-std\\(\\)-?([X-Z])?","StdDeviation\\1",vnames)
names(data_set) <- vnames


# Now we compute the mean of each variable for each subject and each activity:
# We call the resulting dataset "mean_set"

# Found interesting indications on this page:
# http://stackoverflow.com/questions/10787640/ddply-summarize-for-repeating-same-statistical-function-across-large-number-of
library(reshape2)

mdata <- melt(data_set, id.vars=c("activity","subject"))

mean_set <- dcast(mdata, activity + subject ~ variable, mean)

# For reference, can also use the ddply package:
#mean_set <- ddply(data_set, .(activity,subject), numcolwise(mean))

# We now save the mean dataset as "mean_set.txt":
write.table(mean_set,file="mean_set.txt",row.names=FALSE)
