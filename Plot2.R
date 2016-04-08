# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
# plot answering this question.

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

subsetNEIByFIPS <- subset(NEI, fips == "24510")

aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEIByFIPS, sum)

png('plot2.png')
barplot(
        height=aggregatedTotalByYear$Emissions, 
        names.arg=aggregatedTotalByYear$year, 
        xlab="Years", 
        ylab=expression('Total PM'[2.5]*' emission'),
        main=expression('Total PM'[2.5]*' emissions for Baltimore 1999-2008'))
dev.off()
