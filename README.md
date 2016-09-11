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

The data has been split in three data files, the training measurements *X_train.txt*, loaded into *vTrainDataSet* object, the training activities *y_train.txt*, loaded into *vTrainActData* object, and the training subjects *subject_train.txt*, loaded into *vTrainSubjData* object.

      vTrainSetFile <- unz(vZipPath, 'UCI HAR Dataset/train/X_train.txt')
      vTrainSetData <- read.table(vTrainSetFile)

      vTrainActFile <- unz(vZipPath, 'UCI HAR Dataset/train/y_train.txt')
      vTrainActData <- read.table(vTrainActFile)

      vTrainSubjFile <- unz(vZipPath, 'UCI HAR Dataset/train/subject_train.txt')
      vTrainSubjData <- read.table(vTrainSubjFile)

After that, the training activity and subject data sets have been added to the training measurements as new variables called *activity* and *subject*.

      vTrainSetData$activity <- vTrainActData$V1
      vTrainSetData$subject <- vTrainSubjData$V1


Similar to to the training data, the test data has also been loaded directly from the ZIP file. The test measurements *X_test.txt* has been loaded into *vTestSetData* object, the test activities *y_test.txt* has been loaded into *vTestActData* object, and the test subjects *subject_test.txt* into the *vTestSubjData* object.

      vTestSetFile <- unz(vZipPath, 'UCI HAR Dataset/test/X_test.txt')
      vTestSetData <- read.table(vTestSetFile)
      
      vTestActFile <- unz(vZipPath, 'UCI HAR Dataset/test/y_test.txt')
      vTestActData <- read.table(vTestActFile)

      vTestSubjFile <- unz(vZipPath, 'UCI HAR Dataset/test/subject_test.txt')
      vTestSubjData <- read.table(vTestSubjFile)


The test activity and subject data sets have also been added to the test measurements as new variables called *activity* and *subject*.

      vTestSetData$activity <- vTestActData$V1
      vTestSetData$subject <- vTestSubjData$V1


At this point the training and test measurements are loaded, already with their respective activities and subjects. As the next step, they have been merged to create a new data set called *vMergedData*.

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

To extract the required variables from the merged data set, a vector called *vFeatRef* has been created with the elements *activity* and *subject*, the variables previously added, plus all the features from the *vFeatLblData* variable *V1*, which contains the same standard as the variable names in the merged data set (V1, V2, V3, ....).

      vFeatRef <- c('activity', 'subject')
      vFeatRef[3:(nrow(vFeatLblData)+2)] <- vFeatLblData$V1

The second reshaping meant to allow the features names to be used as variable names for the measurements in the merged data set *vMergeData*. As the features names contain characteres which are not valid in variable names, the not valid characters have been removed from them.

      vFeatLblData <- vFeatLblData %>% mutate(V2 = gsub('-','',V2)) %>%
                                       mutate(V2 = gsub(',','',V2)) %>%
                                       mutate(V2 = gsub('\\(','',V2)) %>%
                                       mutate(V2 = gsub('\\)','',V2)) %>%
                                       mutate(V2 = gsub('mean','Mean',V2)) %>%
                                       mutate(V2 = gsub('std','Std',V2))

To accordingly name the variables in the merged data set later, a vector called *vFeatLbl* has been created with the elements *activity* and *subject*, to keep their names when renaming the variables, plus all the features names from the *vFeatLblData* variable *V2*.

      vFeatLbl <- c('activity', 'subject')
      vFeatLbl[3:(nrow(vFeatLblData)+2)] <- as.character(vFeatLblData$V2)      

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

After merging *vMergedData* with the *vActLblData*, both the activity reference numbers and lables are in the merged data set. As result the variable *V2* from the *vMergedData* has been renamed to *V2.x* and the variable *V2* from the *vActLblData* has been renamed to *V2.y*.

The activity reference numbers could be removed, as they are no longer required. The content from the variable *V2.y*, the activity labels, has been copied to the variable *activity*, then the variable *V2.y* has been removed, after that the variable *V2.x* had its name restored to *V2*.

      vMergeData <- vMergeData %>% mutate(activity = V2.y) %>% 
                    select(-V2.y) %>% rename(V2=V2.x)

#### Appropriately label the variable names

Up to here all the required data is in the merged data set *vMergedData*. It is required now to name the variables in the data frame.

Previously the measurements labels have been loaded from the features data file, filtered and stored into the vector *vFeatLbl*. It contains the elements *activity*, *subject* and the required features names, which are going to be used to rename the variables in the merged data set *vMergeData*.

      names(vMergeData) <- vFeatLbl

#### Create a second independet tidy data set

Completing the chalenge, a second independent tidy data set has to be created contaning the average of each variable for each activity and each subject. It could be accomplished using the function *sapply()* together with the function *split()*.

The function *split()* has been used to split the merged data set by *activity* and *subject*, the *sapply()* function has managed to calculate the mean for each measurement, using a anonymous function with *colMeans()* applied to the columns 3 to the last column *(ncol(w)-2)*. The result has been stored into *vSummaryData* object.

      vSummaryData <- sapply(split(vMergeData,
                                   list(vMergeData$activity,vMergeData$subject)
                                   ),
                             function(w) colMeans(w[,3:(ncol(w)-2)])
                             )

But the last procedure had side effects, the first one, the measurements, which originally were variables, became observations, and the original observations, activity and subject, became variables. The data set has been transposed to return to the original shape, using the funtion *t()*. The second side effect, the sapply returned a matrix, then it has also been coerced back to a data frame, using the function *as.data.frame()*.

      vSummaryData <- as.data.frame(t(vSummaryData))

The third side effect, the variables *activity* and *subject* have been lost. Each combination of *activity* and *subject* have been defined as row name and stored together in a single string like *'acticity'.'subject'*. To have them created again as separeted variables in the reshaped *vSummaryData* data frame, the row names have been split using the function *strsplit()* and each peace of it have been extracted with funtion *sapply()*.

      vSummaryData$activity <- sapply(strsplit(row.names(vSummaryData),'\\.'), 
                                      function(k) k[1])
      vSummaryData$subject <- sapply(strsplit(row.names(vSummaryData),'\\.'), 
                                      function(k) k[2])

To have the variables *activity* and *subject* as the first variables, the summary data set has been selected once more.

      vSummaryData <- select(vSummaryData, 
                             activity, subject, 1:(ncol(vSummaryData)-2))

#### Write the Summary Data Set into a file

Finally the tidy data set is ready. The last step is write it into a file, excluding the row names. The resulting file with the Summary Data Set is called *SummaryData.csv* and the function saves it in the current working directory.

      write.csv(vSummaryData,'./SummaryData.csv', row.names = FALSE)

For the user to be able to read the Summary Data Set, the function *read.csv()* can be used.

      read.csv('./SummaryData.csv')

