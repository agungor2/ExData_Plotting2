# Of the four types of sources indicated by the type (point, nonpoint, onroad, 
# nonroad) variable, which of these four sources have seen decreases in emissions 
# from 1999–2008 for Baltimore City? Which have seen increases in emissions from 
# 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.
#######################################################################

library(ggplot2)

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

aggregatedTotalByYearAndType <- aggregate(Emissions ~ year + type, subsetNEIByFIPS, sum)

png("plot3.png", width=640, height=480)
g <- ggplot(aggregatedTotalByYearAndType, aes(year, Emissions, color = type))
g <- g + geom_line() +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle('Total Emissions in Baltimore City, Maryland from 1999 to 2008')
print(g)
dev.off()


