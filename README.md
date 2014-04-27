Getting and Cleaning Data Assignment
=====================================

Assignment for MOOC: Getting and Cleaning Data

This program requires a zip file with Samsung data to work. This data can be downloaded [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ).

This program does three things. It includes a function for each, plus a run() function to execute the script.

With more time, I would have created a separate script to execute the unzipping and extracting of data. I would also have properly commented the files and spent more time thinking about what to call the variables. I expect that, with a file of this size, there is 

But anyway - the functions:


getAllFiles
-------------------
Simple method to unzip file, and return a `file.path` to a temporary directory, where all the data is.

getLabels
------------------
Taking the local filepath to the temporary directory, this method gets the label data: label names for activities (a), index of columns to keep (vix) - only mean and standard deviation variables and column names for those variables (vlb). This is returned in a `list` with keys a, vix and vlb.

open_and_mergeTXT
------------------
Taking the variable data from the above function, this one finds the data from the test/train folders and merges the subject, activity and features data. It returns a `data.frame`

getColM
-------
Uses the `colMeans` function to calculate column means

getAverages
-----------
Gets a `data.frame` of all the possible values of activity and subject and calls the above method. Then uses a `do.call` of `rbind` to convert the `list` from an `lapply` to put it all together

run
---
Runs all of the above code
