## This script processes a subset of the data available from the Human Activity Recognition 
## Using Smartphones Data Set.
##
## The site of the original data:
##   http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##
## Data to be used with these scripts:
##   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
##
## Example Usage:
## > DT <- tidyAndGroupData("UCI HAR Dataset")
## > write.table(DT, "tidy_data.txt", sep=",", row.name=FALSE)


## This is the core function, which creates the tidy and grouped data set.
##
## Params:
##   subDir: The name of the subdirectory inside your working directory that contains the data.
##           If you leave this blank, the code assumes a directory called "UCI HAR Dataset".
## Returns:
##   A data frame, please see the CodeBook.md file for an explanation of this data frame.
tidyAndGroupData <- function(subDir="UCI HAR Dataset")
{
    ## get an array of column indexes of the columns we care about (only std and mean columns)
    columnIndexes <- getColumnIndexes(subDir)
    
    ## get the two partitioned data sets
    dataSet.train <- getDataSet(subDir, "train", columnIndexes)
    dataSet.test <- getDataSet(subDir, "test", columnIndexes)
    
    ## combine all of the rows in the two data sets
    dataSet.all <- rbind(dataSet.train, dataSet.test)

    ## fix up the names in the combined data set
    columnNames <- getColumnNames(subDir, columnIndexes)    
    names(dataSet.all) <- columnNames
    
    ## compute the mean of every variable, grouped by Activity and Subject
    dataSet.grouped <- aggregate(formula=. ~ Activity + Subject, data=dataSet.all, FUN=mean)
    
    ## return the data set
    dataSet.grouped
}


## A function that retrieves the column data from disk.
##
## Params:
##   subDir: The name of the subdirectory inside your working directory that contains the data.
## Returns:
##   A data frame with two columns (index, name).
getColumnsData <- function(subDir)
{
    columnsFileName <- file.path(getwd(), subDir, "features.txt")
    columns <- read.table(columnsFileName, header=FALSE, sep=" ", stringsAsFactors=FALSE)
    columns    
}


## A function that returns an array of cleaned column names that is a subset of the full set.
##
## Params:
##   subDir: The name of the subdirectory inside your working directory that contains the data.
##   columnIndexes: An array of integers that are the indexes of the column names to be returned.
## Returns:
##   An array of cleaned column names.
getColumnNames <- function(subDir, columnIndexes)
{
    ## get all of the columns
    columns <- getColumnsData(subDir)  
    
    ## store a subset of the column names
    columnNames.raw <- columns[columnIndexes, 2]
    
    ## initialize our return set with our custom column names
    columnNames.cleaned <- c("Subject", "Activity") 
    
    ## for every column name
    ##  - remove instances of "()"
    ##  - replace instances of "-" with "."
    ##  - if the name starts with "t", replace it with "Time."
    ##  - if the name starts with "f", replace it with "Freq."
    ##  - add the cleaned name to the return set
    for (i in 1:length(columnNames.raw))
    {
        tempName <- columnNames.raw[i]
        
        tempName <- gsub("\\()", "", tempName)
        tempName <- gsub("\\-", ".", tempName)
        if (substr(tempName, 1, 1) == "t")
        {
            tempName <- sub("t", "Time.", tempName)
        }
        else
        {
            tempName <- sub("f", "Freq.", tempName)
        }
        
        columnNames.cleaned <- c(columnNames.cleaned, tempName)
    }
    
    ## return the cleaned names
    columnNames.cleaned
}


## A function that returns an array of column indexes that is a subset of the full set, only
## the indexes of columns who were defined using mean() or std() are returned.
##
## Params:
##   subDir: The name of the subdirectory inside your working directory that contains the data.
## Returns:
##   An array of column indexes of the mean() and std() variables.
getColumnIndexes <- function(subDir)
{
    ## get all of the columns
    columns <- getColumnsData(subDir)    
   
    ## declare our return set
    columnIndexes <- NULL
    
    ## for every column, check to see if the column name contains "mean()" or "std()", if so 
    ## add that column's index to our return set 
    for (i in 1:nrow(columns))
    {
        columnIndex <- columns[i,1]
        columnName <- columns[i,2]
        
        grepResult <- grep("mean()", columnName, fixed=TRUE)
        if (length(grepResult) != 0 && grepResult == 1)
        {
            columnIndexes <- c(columnIndexes, columnIndex)
        }
        
        grepResult <- grep("std()", columnName, fixed=TRUE)
        if (length(grepResult) != 0 && grepResult == 1)
        {
            columnIndexes <- c(columnIndexes, columnIndex)
        }
    }
    
    ## return the indexes
    columnIndexes
}


## A function that merges the subject, activity and variable data of the desired set into 
## a single data frame.  Activity values are also denormalized into their textual values.  The
## variable data is also partitioned based on the columnIndexes param.
##
## Params:
##   subDir: The name of the subdirectory inside your working directory that contains the data.
##   setDir: The name of the set that should be processed ("train", "test").
##   columnIndexes: An array of integers that denote the columns to be returned from the 
##                  data sets.
## Returns:
##   The processed data frame for the set.
getDataSet <- function(subDir, setDir, columnIndexes)
{
    ## load the subjects data
    subjectsFileName <- file.path(getwd(), subDir, setDir, paste("subject_", setDir, ".txt", sep=""))
    subjects <- read.table(subjectsFileName, header=FALSE)
    
    ## load the raw activities data
    activitiesFileName <- file.path(getwd(), subDir, setDir, paste("y_", setDir, ".txt", sep=""))
    activities.raw <- read.table(activitiesFileName, header=FALSE)
    
    ## declare our decoded activites variable
    activities.decoded <- NULL
    
    ## for every raw activity value, compute the more pleasing activity name and add that to our
    ## activities.decoded set
    for(i in 1:nrow(activities.raw))
    {
        activityCode <- as.numeric(activities.raw[i,1])
        if (activityCode == 1)
        {
            activities.decoded <- c(activities.decoded, "Walking")
        }
        else if (activityCode == 2)
        {
            activities.decoded <- c(activities.decoded, "Walking Upstairs")
        }
        else if (activityCode == 3)
        {
            activities.decoded <- c(activities.decoded, "Walking Downstairs")
        }
        else if (activityCode == 4)
        {
            activities.decoded <- c(activities.decoded, "Sitting")
        }
        else if (activityCode == 5)
        {
            activities.decoded <- c(activities.decoded, "Standing")
        }
        else if (activityCode == 6)
        {
            activities.decoded <- c(activities.decoded, "Laying")
        }
    }
    
    ## load the desire data file with the variable data
    dataFileName <- file.path(getwd(), subDir, setDir, paste("X_", setDir, ".txt", sep=""))
    data.raw <- read.table(dataFileName, header=FALSE)

    ## subset the raw data, partitioning it by the passed in columnIndexes
    resultDataSet <- data.raw[,columnIndexes]
    
    ## combine the three sets of columns into the final data frame
    resultDataSet <- cbind(subjects, activities.decoded, resultDataSet)

    ## return the data
    resultDataSet
}