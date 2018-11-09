require(ggplot2)
require(dplyr)

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

## How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
baltcitymary.emissions<-NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]
baltcitymary.emissions.byyear <- summarise(group_by(baltcitymary.emissions, year), Emissions=sum(Emissions))

png("plot5.png")
ggplot(baltcitymary.emissions.byyear, aes(x=factor(year), y=Emissions,fill=year, label = round(Emissions,2))) +
  geom_bar(stat="identity") +
  xlab("year") +
  ylab(expression("total PM"[2.5]*" emissions in tons")) +
  ggtitle("Emissions from motor vehicle sources in Baltimore City")+
  geom_label(aes(fill = year),colour = "white", fontface = "bold")
dev.off()