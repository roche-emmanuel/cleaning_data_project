# Getting and Cleaning Data Project

The script **run_analysis.R** from this project can be executed to generate tidy data from the Samsumg dataset as described on the **Getting and Cleaning Data** project on Coursera.

The script will load the train and test datasets (eg. the "subjects", "labels" and "features" data files) and merge them together to produce a single data frame.

Note that in this data frame we only keep the mean and standard deviation variables from the initial features.

The script will also use appropriate names for the label values (eg. corresponding to different activities), and rename all the variables from the syntax "-mean()-X" to "MeanX" for instance (eg. removing "-" and parenthesis).

Once this tidy data frame is setup, the script performs the generation of the final "mean" dataset (written to file as "mean_set.txt" in the current working directory): this final data set contains the average value for each variable for each activity and for each subject.

**Important note**: this script excepts the Samsumg data do be available in the current working directory (eg. in a sub folder called "UCI HAR Dataset")
