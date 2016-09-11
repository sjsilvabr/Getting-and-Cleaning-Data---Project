# Getting and Cleaning Data - Course Project
Repository for the Course Project - Getting and Cleaning Data

This repository contains the following files:

1. README.md - this file, contains the explanation of the analysis done via script in R.
2. CodeBook.md - it contains the description for the data sets and variables.
3. run_analysis.R - the script in R.
4. SummaryData.csv - the tidy data set with the average for the variables, result of the analysis.

### Introduction
The purpose of this document is to explain the analysis done via script in R, as Course Project for the Getting and Cleaning Data.

As basis for the analysis a URL containing a data set of the Human Activity Recognition Using Smartphones Data Set from the UCI Machine Learning Repository has been provided.

More information about the source is available at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

More information about the data set is available in the Code Book (CodeBook.md)

The goal of the analysis is to provide a tidy data set with the average of the measurements on the mean and standard deviation from the original data set.

### Information about the script

The script has been written in one function called *tidy_DataSet()*, stored into the file *run_analysis.R*, a copy has been provided in this repository. After saving the file locally, it should be loaded via function *source()* directly in R console.

      source('run_analysis.R')

From this point the function *tidy_DataSet()* is available for use.

      tidy_DataSet()
      
The package dplyr has been used in this script, it has been loaded in the function.

      tidy_DataSet <- function(){
            library(dplyr)

### The Analysis      

#### Load and merge the data

Initially it has been checked if the required data set is already available, if it is not, the data set should be downloaded from the web using the given URL and stored in a accessable unit, the current working directory has been choosen (./). The original data set is in ZIP format.

      vZipPath <- './CourseProjectDataSet.zip'
      if (!file.exists(vZipPath)){
            vURL1 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
            download.file(vURL1, vZipPath, method = 'curl')
      }

Having the original data set available, the data for the training has been loaded directly from the ZIP file.

The data has been split in two data files, the training measurements *X_train.txt*, loaded into *vTrainDataSet* object, and the training activities *y_train.txt*, loaded into *vTrainActData* object.

      vTrainSetFile <- unz(vZipPath, 'UCI HAR Dataset/train/X_train.txt')
      vTrainSetData <- read.table(vTrainSetFile)

      vTrainActFile <- unz(vZipPath, 'UCI HAR Dataset/train/y_train.txt')
      vTrainActData <- read.table(vTrainActFile)

After that, the training activities data set has been added to the training measurements as a new variable called *activity*.

      vTrainSetData$activity <- vTrainActData$V1

Similar to to the training data, the test data has also been loaded directly from the ZIP file. The test measurements *X_test.txt* has been loaded into *vTestSetData* object, and the test activities *y_test.txt* has been loaded into *vTestActData* object.

      vTestSetFile <- unz(vZipPath, 'UCI HAR Dataset/test/X_test.txt')
      vTestSetData <- read.table(vTestSetFile)
      
      vTestActFile <- unz(vZipPath, 'UCI HAR Dataset/test/y_test.txt')
      vTestActData <- read.table(vTestActFile)

The test activities data set has also been added to the test measurements as a new variable called *activity*.

      vTestSetData$activity <- vTestActData$V1

At this point the training and test measurements are loaded, already with their respective activities. As the next step, they have been merged to create a new data set called *vMergedData*.

      vMergeData <- merge(vTrainSetData, vTestSetData, all=TRUE)

#### Extract the measurements on the mean and standard deviation

The merged data set contains the data from the training and test data set, including all the measurements. It is required to extract from this huge data set only the measurements on the mean and standard deviation.

For this task the features data file *features.txt* has been used, it contains all the variables names in the order as they appear in the training and test data sets, now merged in one data set. Containing all the variables names, it can be used to extract the required measurements, mean and standard deviation, and can also be used later to name the variables in the merged data set accordingly. It has been loaded loaded from the ZIP file into *vFeatLblData* object.

      vFeatLblFile <- unz(vZipPath, 'UCI HAR Dataset/features.txt')
      vFeatLblData <- read.table(vFeatLblFile)

First the features data set has been filtered to keep only the variables which the name contains the words *'mean'* or *'std'*.

      vFeatLblData <- filter(vFeatLblData, 
                             (grepl('mean',V2, ignore.case = TRUE) | 
                              grepl('std',V2, ignore.case = TRUE))
                             )

Having only the features for the required variables, two reshaping actions should be done to it.
 
The first is supposed the allow it to be matched to the original variables names (V1, V2, V3, ...) in the merged data set *vMergeData*, and extract from it only the required variables. It has been achieved adding the letter *'V'* in front of the feature position, the variable *V1* in the *vFeatLblData*.
 
       vFeatLblData <- vFeatLblData %>% 
            mutate(V1 = paste(rep('V',nrow(vFeatLblData)), vFeatLblData$V1)) %>%
            mutate(V1 = gsub(' ', '', V1))

To extract the required variables from the merged data set, a vector called *vFeatRef* has been created with the element *activity*, the variable previously added, and all the features from the *vFeatLblData* variable *V1*, which contains the same standard as the variable names in the merged data set (V1, V2, V3, ....).

      vFeatRef <- 'activity'
      vFeatRef[2:(nrow(vFeatLblData)+1)] <- vFeatLblData$V1

The second reshaping meant to allow the features names to be used as variable names for the measurements in the merged data set *vMergeData*. As the features names contain characteres which are not valid in variable names, the not valid characters have been removed from them.

      vFeatLblData <- vFeatLblData %>% mutate(V2 = gsub('-','',V2)) %>%
                                       mutate(V2 = gsub(',','',V2)) %>%
                                       mutate(V2 = gsub('\\(','',V2)) %>%
                                       mutate(V2 = gsub('\\)','',V2)) %>%
                                       mutate(V2 = gsub('mean','Mean',V2)) %>%
                                       mutate(V2 = gsub('std','Std',V2))

To accordingly name the variables in the merged data set later, a vector called *vFeatLbl* has been created with the element *activity*, to keep its name when renaming the variables, and all the features names from the *vFeatLblData* variable *V2*.

      vFeatLbl <- 'activity'
      vFeatLbl[2:(nrow(vFeatLblData)+1)] <- as.character(vFeatLblData$V2)      

Being ready to extract the required variables from the merged data set, it has been done using the vector *vFeatRef* to subset the data frame *vMergedData*.

     vMergeData <- vMergeData[,vFeatRef]

#### Use descriptive activity names

The merged data frame *vMergedData* has been reduced to the required variables plus the activities. Next task is to use descriptive activity names.

To manage this task the activities lables data file *activity_labels.txt* has been used, it contains the lables for the activities, which have been initially added as part of the training and test data sets. The activities lables data file has been loaded from the ZIP into *vActLblData* object.

      vActLblFile <- unz(vZipPath, 'UCI HAR Dataset/activity_labels.txt')
      vActLblData <- read.table(vActLblFile)

Merging the data frame *vMergedData* with the *vActLblData*, having variable *activity* from the first linked to variable *V1* into second, has added the activities lables to the merged data set.

      vMergeData <- merge(vMergeData, vActLblData, 
                    by.x='activity', by.y='V1', all=TRUE)

After merging *vMergedData* with the *vActLblData*, the activities reference numbers and lables are in the merged data set. As result the variable *V2* from the *vMergedData* has been renamed to *V2.x* and the variable *V2* from the *vActLblData* has been renamed to *V2.y*.

The activites reference numbers could be removed, as they are no longer required. The content from the variable *V2.y*, the activities labels, has been copied to the variable *activity*, then the variable *V2.y* has been removed, after that the variable *V2.x* had its name restored to *V2*.

      vMergeData <- vMergeData %>% mutate(activity = V2.y) %>% 
                    select(-V2.y) %>% rename(V2=V2.x)

#### Appropriately label the variable names

Up to here all the required data is in the merged data set *vMergedData*. It is required now to name the variables in the data frame.

Previously the measurements labels have been loaded from the features data file, filtered and stored into the vector *vFeatLbl*. It contains the element *activity* and the required features names, which are going to be used to rename the variables in the merged data set *vMergeData*.

      names(vMergeData) <- vFeatLbl

#### Create a second independet tidy data set

Completing the chalenge, a second independent tidy data set has to be created contaning the average of each variable for each activity and each subject. It could be accomplished using the function *sapply()* together with the function *split()*.

The function *split()* has been used to split the merged data set by *activity* and the *sapply()* function managed to calculate the mean, function *colMeans()*, for each variable, except for the *activity*, using a anonymous function. The result has been stored into *vSummaryData* object.

      vSummaryData <- sapply(split(vMergeData,vMergeData$activity),
                             function(w) colMeans(w[,2:(ncol(w)-1)])
                             )

But the last procedures had a side effects, the first one, the measurements, which originally were variables, became observations, and the activities became variables. The data set has been transposed to return to the original shape, using the funtion *t()*. The second side effect, the sapply returned a matrix, it has also been coerced back to a data frame, using the function *as.data.frame()*.

      vSummaryData <- as.data.frame(t(vSummaryData))

The third side effect, as matrix, the activities have been defined as row names, and the variable *activity* has been lost. It has been created again in the reshaped *vSummaryData* data frame with the content row names, and to have it as the first variable the summary data set has been selected once more.

      vSummaryData$activity <- row.names(vSummaryData)
      vSummaryData <- select(vSummaryData, activity, 1:(ncol(vSummaryData)-1))

#### Write the Summary Data Set into a file

Finally the tidy data set is ready. The last step is write it into a file, excluding the row names. The resulting file with the Summary Data Set is called *SummaryData.csv* and the function saves it in the current working directory.

      write.csv(vSummaryData,'./SummaryData.csv', row.names = FALSE)

For the user to be able to read the Summary Data Set, the function *read.csv()* can be used.

      read.csv('./SummaryData.csv')

