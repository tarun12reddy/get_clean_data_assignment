# find and unzip files

# load the variable names
# get the variables that we want
# separate out the mean and the sd ones


# open text files and tidy
# keep only data we need
# name variables
# factorize activities
# merge test and training

# use in data.table...? Or just split the data frame?

getAllFiles <-  function(zipfile){
    tdir <- tempdir()
    unzip(zipfile, exdir=tdir)
    file.path(tdir, 'UCI HAR Dataset')
}


getLabels <- function(ffpth){
    acts <- read.table(file.path(ffpth, 'activity_labels.txt'))
    vbs <- read.table(file.path(ffpth, 'features.txt'))
    vbs <- as.character(vbs[,2])
    our_vrbs <- grep("(std|mean)\\(\\)", vbs) # gets standard deviation or (|) mean
    our_vrbs_labs <- vbs[our_vrbs] # character vector of labels
    list(a=as.character(acts[,2]), vix=our_vrbs, vlb=our_vrbs_labs)
}


open_and_mergeTXT <- function(ffpth, vrbIx, vrbNms, actNames, fld){
    sbj <- as.numeric(readLines(file.path(ffpth, paste0('subject_', fld, '.txt'))))
    act <- as.numeric(readLines(file.path(ffpth, paste0('y_', fld, '.txt'))))
    act <- factor(act, labels=actNames)
    ftrs <- read.table(file.path(ffpth, paste0('X_', fld, '.txt')))
    ftrs <- ftrs[,vrbIx]
    colnames(ftrs) <- vrbNms
    ftrs$sbj <- sbj
    ftrs$act <- act
    ftrs
}

getColM <- function(x, asdf=null, dt=NULL){
    a<-asdf[x,'a']
    s<-asdf[x,'s']
    sbD  <- dt[dt$act==a & dt$sbj == s,]
    cm <- colMeans(sbD[1:66]) # or possibly with var names?
    cm <- as.data.frame(t(cm))
    cm$sbj <- s
    cm$act <- a
    cm
}

getAverages<-function(ftDB){
    s<-unique(ftDB$sbj)
    a <- levels(ftDB$act)
    print(a)
    print(s)
    as_df <- data.frame(a=rep(a, length(s)), s=rep(s, each=length(a)))
    print(nrow(as_df))
    do.call(rbind, lapply(row.names(as_df), getColM, as_df, dt=ftDB))
}

run <- function(zipfile){
    localpath <- getAllFiles(zipfile)
    tst <- open_and_mergeTXT(file.path(localpath, 'test'), lbls$vix, lbls$vlb, lbls$a, 'test')
    both <- rbind(tst, open_and_mergeTXT(file.path(localpath, 'train'), lbls$vix, lbls$vlb, lbls$a, 'train'))
    getAverages(both)
}
