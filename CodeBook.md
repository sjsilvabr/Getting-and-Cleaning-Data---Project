# Getting and Cleaning Data - Course Project
Repository for the Course Project - Getting and Cleaning Data

## Code Book

### The source

The basis for the analysis is a data set containing data collect from the experiment Human Activity Recognition Using Smartphones Data Set from the UCI Machine Learning Repository.

The data set for has be available for download at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

More information about the source is available at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Regarding the experiment, the following text has been extracted from the source web page above:

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.*

>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Regarding the variables, the following text has been extracted from the source, file *features_info.txt*:

>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

>These signals were used to estimate variables of the feature vector for each pattern:'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

>- tBodyAcc-XYZ
- tGravityAcc-XYZ
- tBodyAccJerk-XYZ
- tBodyGyro-XYZ
- tBodyGyroJerk-XYZ
- tBodyAccMag
- tGravityAccMag
- tBodyAccJerkMag
- tBodyGyroMag
- tBodyGyroJerkMag
- fBodyAcc-XYZ
- fBodyAccJerk-XYZ
- fBodyGyro-XYZ
- fBodyAccMag
- fBodyAccJerkMag
- fBodyGyroMag
- fBodyGyroJerkMag

>The set of variables that were estimated from these signals are:

>- mean(): Mean value
- std(): Standard deviation
- mad(): Median absolute deviation 
- max(): Largest value in array
- min(): Smallest value in array
- sma(): Signal magnitude area
- energy(): Energy measure. Sum of the squares divided by the number of values. 
- iqr(): Interquartile range 
- entropy(): Signal entropy
- arCoeff(): Autorregresion coefficients with Burg order equal to 4
- correlation(): correlation coefficient between two signals
- maxInds(): index of the frequency component with largest magnitude
- meanFreq(): Weighted average of the frequency components to obtain a mean frequency
- skewness(): skewness of the frequency domain signal 
- kurtosis(): kurtosis of the frequency domain signal 
- bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
- angle(): Angle between to vectors.

>Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

>- gravityMean
- tBodyAccMean
- tBodyAccJerkMean
- tBodyGyroMean
- tBodyGyroJerkMean

The total acceleration -XYZ is the the acceleration signal from the smartphone accelerometer -XYZ axis in standard gravity units *g*.

The body acceleration -XYZ signal was obtained by subtracting the gravity from the total acceleration, units *g*.

The angular velocity vector -XYZ measured by the gyroscope for each window sample, the units are *radians/second*.

For this course project, only the measurements on average and standard deviation have been selected.

### Content of the provided data set

The provided data set is a ZIP file which contains the following directories and files:

- UCI HAR Dataset *(root directory)*
  - README.txt *(information about the experiment and the content of the data set)*
  - activity_labels.txt *(the lables for the activities performed during the experiments)*
  - features_info.txt *(information about the variables in the feature vector)*
  - features.txt *(the lables for the features)*
  - test *(testing data directory)*
    - Inertial Signals *(this directory has not been used during analysis)*
    - subject_test.txt *(list of the subjects who performed the activities, range from 1 to 30)*
    - X_test.txt *(test data set, each row is a activity performed by a subject with its measurements)*
    - y_test.txt *(test activities, each row identifies de activity performed by the subject)*
  - train *(training data directory)*
    - Inertial Signals *(this directory has not been used during analysis)*
    - subject_train.txt *(list of the subjects who performed the activities, range from 1 to 30)*
    - X_train.txt *(train data set, each row is a activity performed by a subject with its measurements)*
    - y_train.txt *(train activities, each row identifies de activity performed by the subject)*

### The course project

The goal for this course was to combine the training and test data sets, extract only the measurements on mean and standard deviation, use descriptive activities names and variable names and create a second idependent tidy data set with the average of each variable for each activity and subject.

The goal has been achieved via the R script, provided in this repository *run_analysis.R*, and explaned in details in the *README.md*, also provided in this repository.

In summary what has been done:

1. The data set has been downloaded from the provided URL in ZIP format
2. The training and test data sets, including their activities and subjects lists have been loaded from the ZIP file
3. The activities and subjects have been added to the training and test data sets
4. The training and test data sets have been merged in one data set
5. The features labels (measurements) data set has been loaded from the ZIP file
6. The features labels on mean and standard deviation have been selected
7. Using the features lables, only the variables on mean and standard deviation have been extracted from the merged data set
8. The activities lables data set has been loaded from the ZIP file
9. The activities in the merged data set have been updated accordingly with the activities labels
10. The variables (measurements) in the merged data set have been renamed according to the features labels
11. A new tidy data set has been created containing the activies, subjects and the average of the measurements
12. The new tidy data set has been written in a CSV file

### Tidy data set

The resulting *Summary Data Set* is a tidy data set, it complies with the following:

1. Each variable is in one column
2. Each observation is in a different row
