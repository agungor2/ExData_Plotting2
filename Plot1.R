library(dplyr)
library(tidyr)
library(R.utils)
library(useful)
library(pbapply)

#######################################################################

urlLink = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

        baseDir = "."
        subPath = "data"
        zipFileUrl <- urlLink
        destName = "Dataset.zip"
        unzipPath = "data"
# create data sub-directory if necessary
dataDir <<- paste(baseDir, subPath, sep="/")
if(!file.exists(dataDir)) {
        dir.create(dataDir)
} else {
        paste("Directory ", dataDir, " already exists")
}

# download original data if necessary (skip if exists already as it takes time)
zipFilePath <<- paste(dataDir, destName, sep="/")
if (!file.exists(zipFilePath)) {
        download.file (zipFileUrl, zipFilePath, method="auto")
        dateDownloaded <- date()
        
        ##  writing out & appending to a external manifest.md when downloaded
        write(paste ("Dataset downloaded on:", dateDownloaded), "./manifest.md", append=TRUE)
}

unzip(zipFilePath, exdir = dataDir)

if(!exists("NEI")){
        NEI <- readRDS("./data/summarySCC_PM25.rds")
}
if(!exists("SCC")){
        SCC <- readRDS("./data/Source_Classification_Code.rds")
}


#######################################################################

aggregatedTotalByYear <- aggregate(Emissions ~ year, NEI, sum)

# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all 
# sources for each of the years 1999, 2002, 2005, and 2008.

png('plot1.png')
barplot(
        height=aggregatedTotalByYear$Emissions, 
        names.arg=aggregatedTotalByYear$year, 
        xlab="Years", 
        ylab=expression('Total PM'[2.5]*' emission'),
        main=expression('Total PM'[2.5]*' emissions for various years'))
dev.off()

# Total emissions form PM2.5 have decreased in the United States from 1999 to 2008
