# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

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

# fetch all NEIxSCC records with Short.Name (SCC) that contain Coal
coalMatches  <- grepl("coal", NEISCC_tbl$Short.Name, ignore.case=TRUE)
subsetNEISCC <- NEISCC_tbl[coalMatches, ]

aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEISCC, sum)

png("plot4.png", width=640, height=480)
g <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle('Total Emissions from coal sources from 1999 to 2008')
print(g)
dev.off()
