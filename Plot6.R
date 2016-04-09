# Compare emissions from motor vehicle sources in Baltimore City with 
# emissions from motor vehicle sources in Los Angeles County, California 
# (fips == "06037"). Which city has seen greater changes over time in 
# motor vehicle emissions?


#######################################################################

library(ggplot2)

urlLink = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

baseDir  <- "."
subPath  <- "data"
zipFileUrl <- urlLink
destName <- "Dataset.zip"
unzipPath <- "data"
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

# check to see if NEISCC_tbl - the merge of the two is around. It takes a while to build
if(!exists("NEISCC_tbl")) {
        NEISCC_tbl <- merge(NEI, SCC, by="SCC")
}
#######################################################################
fipsBWI <- "24510"  # Baltimore FIPS
fipsLAX <- "06037"  # Los Angeles FIPS
type = "ON-ROAD"

subsetNEI <- NEI[(NEI$fips==fipsBWI | NEI$fips==fipsLAX) & NEI$type==type ,  ]


aggregatedTotalByYearAndFips <- aggregate(Emissions ~ year + fips, subsetNEI, sum)
aggregatedTotalByYearAndFips$fips[aggregatedTotalByYearAndFips$fips==fipsBWI] <- "Baltimore, MD"
aggregatedTotalByYearAndFips$fips[aggregatedTotalByYearAndFips$fips==fipsLAX] <- "Los Angeles, CA"

png("plot6.png", width=1040, height=480)
g <- ggplot(aggregatedTotalByYearAndFips, aes(factor(year), Emissions))
g <- g + facet_grid(. ~ fips)
g <- g + geom_bar(stat="identity")  +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle('Total Emissions from motor vehicle in Baltimore City, MD vs Los Angeles, CA for 1999-2008')
print(g)
dev.off()
