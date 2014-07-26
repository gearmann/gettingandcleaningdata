Getting and Cleaning Data
=========================

This repository contains the course project for the Getting and Cleaning Data course on Coursera.

###Contents
* This `README.md` file
* A script of R code called `run_analysis.R` that can create a tidy data set 
* A code book for the tidy data set called `CodeBook.md`

###Using run_analysis.R
This script processes a subset of the data available from the Human Activity Recognition Using Smartphones Data Set.

The site of the original data:
* http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data to be used with these scripts:
* https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Example Usage:
> DT <- tidyAndGroupData("UCI HAR Dataset")

> write.table(DT, "tidy_data.txt", sep=",", row.name=FALSE)

###Transformations
1. Computes the indexes of the columns of interest (only mean() and std() values)
1. Merges the subject, activity and variable data of each set into a single data frame
1. Subsets each data set by the desired columns' indexes
1. Applies descriptive names for each activity
1. Merges the test and training data sets into one data set
1. Fixes up the variable names in the data set to be more descriptive
1. Computes the mean of every variable, grouping by Activity and Subject
