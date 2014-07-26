Getting and Cleaning Data
=========================

This repository contains the course project for the Getting and Cleaning Data course on Coursera.

###Contents
* This `README.md` file
* A script of R code called `run_analysis.R` that can create a tidy data set 
* A code book for the tidy data set called `CodeBook.md`

###Using run_analysis.R
This script processes a subset of the data available from the Human Activity Recognition Using Smartphones Data Set.  The script assumes that the data is contained in a subdirectory of your working directory.

The site of the original data:
* http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Data to be used with these scripts:
* https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Example Usage:
> DT <- tidyAndGroupData("UCI HAR Dataset")

> write.table(DT, "tidy_data.txt", sep=",", row.name=FALSE)

