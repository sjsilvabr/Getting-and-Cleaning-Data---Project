# Getting and Cleaning Data - Course Project
Repository for the Course Project - Getting and Cleaning Data

## Code Book

### The soure

The basis for the analysis is a data set containing data collect from the experiment Human Activity Recognition Using Smartphones Data Set from the UCI Machine Learning Repository.

The data set for has be available for download at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

More information about the source is available at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Regarding the experiment, the following text has been extract from the source web page above:

> *The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.*

> *The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.*

### Content of the provided data set

The provided data set is a ZIP file which contains the following directories and files:

- UCI HAR Dataset *(root directory)*
  - README.txt *(information about the experiment and the content of the data set)*
  - activity_labels.txt *(the lables for the activities performed during the experiments)*
  - features_info.txt *(information about the variables in the feature vector)*
  - features.txt *(the lables for the features)*
  - test *(testing data directory)*
    - Inertial Signals *(this directory has not been used during analysis)*
    - subject_test.txt *(list of the subjects who performed the activities)*
    - X_test.txt *(test data set)*
    - y_test.txt *(test activities)*
  - train *(training data directory)*
    - Inertial Signals *(this directory has not been used during analysis)*
    - subject_train.txt *(list of the subjects who performed the activities)*
    - X_train.txt *(train data set)*
    - y_train.txt *(train activities)*
