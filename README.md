# Getting-and-Cleaning-Data---Project
Repository for the Course Project - Getting and Cleaning Data

### Introduction
The purpose of this document is to explain the analysis done via script in R, as Course Project for the Getting and Cleaning Data.

As basis for the analysis a URL containing a data set of the Human Activity Recognition Using Smartphones Data Set from the UCI Machine Learning Repository has been provided.

More information about the source is available at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

More information about the data set is available in the Code Book (CodeBook.md)

The goal of the analysis is to provide a tidy data set with the average of the measurements from the original data set.

### The analysis

The script has been written in one function called tidy_DataSet() stored on the file run_analysis.R. 
The package dplyr has been used, for this it has been loaded in the function.

      library(dplyr)

#### Load and Merge the data

Initially it has been checked if the required data set is already available, if it is not, the data set should be downloaded from the web using the given URL and stored in a accessable unit, the current working directory has been choosen (./). The original data set is in ZIP format.

      vZipPath <- './CourseProjectDataSet.zip'
      if (!file.exists(vZipPath)){
            vURL1 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
            download.file(vURL1, vZipPath, method = 'curl')
      }

Having the original data set available, the data for the training has been loaded directly from the ZIP file.

The data has been split in two data files, the training measurements (X_train.txt), loaded into 'vTrainDataSet' object, and the training activities (y_train.txt), loaded into 'vTrainActData' object.

      vTrainSetFile <- unz(vZipPath, 'UCI HAR Dataset/train/X_train.txt')
      vTrainSetData <- read.table(vTrainSetFile)

      vTrainActFile <- unz(vZipPath, 'UCI HAR Dataset/train/y_train.txt')
      vTrainActData <- read.table(vTrainActFile)

After that, the training activities data set has been added to the training measurements as a new variable called 'activity'.

      vTrainSetData$activity <- vTrainActData$V1

Similar to to the training data, the test data has also been loaded directly from the ZIP file. The test measurements (X_test.txt) has been loaded into 'vTestSetData' object, and the test activities (y_test.txt) has been loaded into 'vTestActData' object.

      vTestSetFile <- unz(vZipPath, 'UCI HAR Dataset/test/X_test.txt')
      vTestSetData <- read.table(vTestSetFile)
      
      vTestActFile <- unz(vZipPath, 'UCI HAR Dataset/test/y_test.txt')
      vTestActData <- read.table(vTestActFile)

The test activities data set has also been added to the test measurements as a new variable called 'activity'.

      vTestSetData$activity <- vTestActData$V1

At this point the training and test measurements are loaded, already with the activities. As next step they have been merged to create a new data set called 'vMergedData'.

      vMergeData <- merge(vTrainSetData, vTestSetData, all=TRUE)

#### Extract the measurements on the mean and standard deviation

The merged data set contains the data from the training and test data set, including all the measurements. It is required to extract from this huge data set only the measurements on the mean and standard deviation.

For this task the features data file (features.txt) has been used, it contains all the variable names in the order as they appear in the training and test data sets, now merged in one data set. Having all the variable names, it can be used to extract the required measurements, mean and standard deviation, and can also be used to name the variables accordingly. It has been loaded in 'vFeatLblData' object.

      vFeatLblFile <- unz(vZipPath, 'UCI HAR Dataset/features.txt')
      vFeatLblData <- read.table(vFeatLblFile)

First the features data set has been filtered to keep only the variables which the name contains the words 'mean' or 'std'.

      vFeatLblData <- filter(vFeatLblData, 
                             (grepl('mean',V2, ignore.case = TRUE) | 
                              grepl('std',V2, ignore.case = TRUE))
                             )

Having only the features for the required variables, two reshaping actions should be done to it.
 
The first is supposed the allow it to be matched to the variable names in the merged data set 'vMergeData', and extract from it only the required variables, on mean and standard deviation measurements. It has been achieved adding the letter 'V' in front of the feature position, the variable 'V1' in the 'vFeatLblData'.
 
       vFeatLblData <- vFeatLblData %>% 
            mutate(V1 = paste(rep('V',nrow(vFeatLblData)), vFeatLblData$V1)) %>%
            mutate(V1 = gsub(' ', '', V1))

To extract the required variables from the merged data set, a vector called 'vFeatRef' has been created with the element 'activity' and all the features from the 'vFeatLblData' variable 'V1', which contains the same standard as the variable names in the merged data set (V1, V2, V3, ....).

      vFeatRef <- 'activity'
      vFeatRef[2:(nrow(vFeatLblData)+1)] <- vFeatLblData$V1

The second reshaping ment to allow the features names to be used as variable names for the measurements in the merged data set 'vMergeData'. As the features names contain characteres which are not valid in variable names, the not valid characters have been removed from the features names.

      vFeatLblData <- vFeatLblData %>% mutate(V2 = gsub('-','',V2)) %>%
                                       mutate(V2 = gsub(',','',V2)) %>%
                                       mutate(V2 = gsub('\\(','',V2)) %>%
                                       mutate(V2 = gsub('\\)','',V2)) %>%
                                       mutate(V2 = gsub('mean','Mean',V2)) %>%
                                       mutate(V2 = gsub('std','Std',V2))

To accordingly name the variables in the merged data set, a vector called 'vFeatLbl' has been created with the element 'activity', to keep its name, and all the features names from the 'vFeatLblData' variable 'V2'.

      vFeatLbl <- 'activity'
      vFeatLbl[2:(nrow(vFeatLblData)+1)] <- as.character(vFeatLblData$V2)      

Being ready to extract the required variables from the merged data set, it has been done using the vector 'vFeatRef' to subset the data frame 'vMergedData'.

     vMergeData <- vMergeData[,vFeatRef]
