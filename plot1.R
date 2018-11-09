NEI <- "summarySCC_PM25.rds"
SCC <- "Source_Classification_Code.rds"
dataSet <- "exdata%2Fdata%2FNEI_data.zip"

## if data set file doesn't exist, download and unzip it
if (!file.exists(NEI,SCC)) {
  dataSetUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(dataSetUrl, destfile = dataSet)
  unzip(dataSet)
}

## read data sets
NEI <- readRDS(NEI)
SCC <- readRDS(SCC)

## Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
## Using the base plotting system, make a plot showing the total PM2.5 emission from all sources
## for each of the years 1999, 2002, 2005, and 2008.
totalEmissionByYear <- aggregate(NEI$Emissions , by = list(NEI$year), FUN = sum)

png(filename = "plot1.png")
plot1 <- barplot(height = totalEmissionByYear[[2]] / 1000, 
                 names.arg = totalEmissionByYear[[1]], 
                 xlab = "Years",
                 ylab = expression("total PM"[2.5]*" emission in Kilotons"),
                 main = expression("Total PM"[2.5]*" emissions at various years in Kilotons"),
                 ylim = c(0,8000))
text(x = plot1, y = round(totalEmissionByYear[[2]] / 1000, 2), label = round(totalEmissionByYear[[2]] / 1000, 2), pos = 3, cex = 0.8, col = "red")
dev.off()