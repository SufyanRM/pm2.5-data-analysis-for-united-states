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

## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips=="24510")
## from 1999 to 2008? the base plotting system to make a plot answering this question.
baltimore <- NEI[NEI$fips == "24510", ]
totalEmissionByYear <- aggregate(baltimore$Emissions, by = list(baltimore$year), FUN = sum)

png(filename = "plot2.png")
plot1 <- barplot(height = totalEmissionByYear[[2]] / 1000, 
                 names.arg = totalEmissionByYear[[1]], 
                 xlab = "Years",
                 ylab = expression("total PM"[2.5]*" emission in Kilotons"),
                 main = expression("Total PM"[2.5]*" emissions in Baltimore City at various years in Kilotons"),
                 ylim = c(0,4))
text(x = plot1, y = round(totalEmissionByYear[[2]] / 1000, 2), label = round(totalEmissionByYear[[2]] / 1000, 2), pos = 3, cex = 0.8, col = "red")
dev.off()