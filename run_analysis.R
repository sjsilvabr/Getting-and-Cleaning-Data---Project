# Data Science Specialization - Johns Hopkins University on Coursera
# Course 3 - Getting and Cleaning Data
# Course Project by Sidclay da Silva
# September 2016

# Function to load the data set, tidy the data and
# write a file with the required calculation
tidy_DataSet <- function(){
      # Load required package
      library(dplyr)

      # Define the path and name to download the ZIP file
      vZipPath <- './CourseProjectDataSet.zip'
      
      # Check if the required file already exists, if not download it
      if (!file.exists(vZipPath)){
            # Download the data set from the provided URL
            vURL1 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
            download.file(vURL1, vZipPath, method = 'curl')
      }
      
      # Load the Training data set from the ZIP file
      vTrainSetFile <- unz(vZipPath, 'UCI HAR Dataset/train/X_train.txt')
      vTrainSetData <- read.table(vTrainSetFile)

      # Load the Training Activities from the ZIP file
      vTrainActFile <- unz(vZipPath, 'UCI HAR Dataset/train/y_train.txt')
      vTrainActData <- read.table(vTrainActFile)

      # Load the Training Subjects from the ZIP file
      vTrainSubjFile <- unz(vZipPath, 'UCI HAR Dataset/train/subject_train.txt')
      vTrainSubjData <- read.table(vTrainSubjFile)
      
      # Create the variable activity in the Training data frame
      # with the values from Training Activities data frame
      vTrainSetData$activity <- vTrainActData$V1
      
      # Create the variable subject in the Training data frame
      # with the values from Training Subjects data frame
      vTrainSetData$subject <- vTrainSubjData$V1

      # Load the Test data set from the ZIP file
      vTestSetFile <- unz(vZipPath, 'UCI HAR Dataset/test/X_test.txt')
      vTestSetData <- read.table(vTestSetFile)
      
      # Load the Test Activities from the ZIP file
      vTestActFile <- unz(vZipPath, 'UCI HAR Dataset/test/y_test.txt')
      vTestActData <- read.table(vTestActFile)
      
      # Load the Test Subjects from the ZIP file
      vTestSubjFile <- unz(vZipPath, 'UCI HAR Dataset/test/subject_test.txt')
      vTestSubjData <- read.table(vTestSubjFile)
      
      # Create the variable activity in the Test data frame
      # with the values from Test Activities data frame
      vTestSetData$activity <- vTestActData$V1

      # Create the variable subject in the Test data frame
      # with the values from Test Subjects data frame
      vTestSetData$subject <- vTestSubjData$V1
      
      # Merge the Training and Test data frames into a new data frame
      vMergeData <- merge(vTrainSetData, vTestSetData, all=TRUE)

      # Load the Features Labels (measurements) data set from the ZIP file
      vFeatLblFile <- unz(vZipPath, 'UCI HAR Dataset/features.txt')
      vFeatLblData <- read.table(vFeatLblFile)

      # Select from the Features Lables data frame only the variables names
      # which contain the words mean or std
      vFeatLblData <- filter(vFeatLblData, 
                             (grepl('mean',V2, ignore.case = TRUE) | 
                              grepl('std',V2, ignore.case = TRUE))
                             )
            
      # Add the V to the Features Labels reference numbers (V1) 
      # to match them to the Merged data frame
      vFeatLblData <- vFeatLblData %>% 
            mutate(V1 = paste(rep('V',nrow(vFeatLblData)), vFeatLblData$V1)) %>%
            mutate(V1 = gsub(' ', '', V1))

      # Define a vector with the Features Labels (Measurements) references 
      # (V1, V2, ...) from the Features Labels data frame
      vFeatRef <- c('activity', 'subject')
      vFeatRef[3:(nrow(vFeatLblData)+2)] <- vFeatLblData$V1
      
      # Adjust the Fetures Lables (V2) to be variable names
      # removing not valid characters
      vFeatLblData <- vFeatLblData %>% mutate(V2 = gsub('-','',V2)) %>%
            mutate(V2 = gsub(',','',V2)) %>%
            mutate(V2 = gsub('\\(','',V2)) %>%
            mutate(V2 = gsub('\\)','',V2)) %>%
            mutate(V2 = gsub('mean','Mean',V2)) %>%
            mutate(V2 = gsub('std','Std',V2))
      
      # Define a vector with the Features Lables (Measurements)
      # from the Features Labels data frame
      vFeatLbl <- c('activity', 'subject')
      vFeatLbl[3:(nrow(vFeatLblData)+2)] <- as.character(vFeatLblData$V2)      

      # Extract the Features (Measurements) on the mean and standard deviation
      # from the Merged data frame using the Features Lables references
      vMergeData <- vMergeData[,vFeatRef]

      # Load the Activities Labels data set from the ZIP file
      vActLblFile <- unz(vZipPath, 'UCI HAR Dataset/activity_labels.txt')
      vActLblData <- read.table(vActLblFile)

      # Merge the Merged data frame with the Activities Labels
      vMergeData <- merge(vMergeData, vActLblData, 
                    by.x='activity', by.y='V1', all=TRUE)

      # Change the variable activity from reference numbers to lables
      # in the Merged data frame
      vMergeData <- vMergeData %>% mutate(activity = V2.y) %>% 
                    select(-V2.y) %>% rename(V2=V2.x)

      # Change the variable names (Measurements) in the Merged data frame 
      # using the Features Labels
      names(vMergeData) <- vFeatLbl

      # Create an independet data set with the average of all measurements
      # Calculate the average for each measurement by activity and subject
      vSummaryData <- sapply(split(vMergeData,
                                   list(vMergeData$activity,vMergeData$subject)
                                   ),
                             function(w) colMeans(w[,3:(ncol(w)-2)])
                             )

      # Reshape it transposing rows and columns and coercing it to data frame
      vSummaryData <- as.data.frame(t(vSummaryData))

      # Add the activity and subject as variables from the row names split
      # between activity and subject using the . as separator
      vSummaryData$activity <- sapply(strsplit(row.names(vSummaryData),'\\.'), 
                                      function(k) k[1])
      vSummaryData$subject <- sapply(strsplit(row.names(vSummaryData),'\\.'), 
                                      function(k) k[2])

      vSummaryData <- select(vSummaryData, 
                             activity, subject, 1:(ncol(vSummaryData)-2))

      # Write the Summary data frame into a CSV file
      write.csv(vSummaryData,'./SummaryData.csv', row.names = FALSE)
      
}