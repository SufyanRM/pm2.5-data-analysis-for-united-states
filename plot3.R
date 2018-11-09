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

## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
## which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?
## Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make
## a plot answer this question.
baltimoreNEI<-summarise(group_by(filter(NEI, fips == "24510"), year,type), Emissions=sum(Emissions))

png("plot3.png")
ggplot(baltimoreNEI, aes(factor(year), Emissions, fill = type, label = round(Emissions, 2))) +
  geom_bar(stat = "identity") +
  facet_grid(. ~ type) + 
  xlab("year") +
  ylab(expression("total PM"[2.5]*" emission in tons")) +
  ggtitle(expression("PM"[2.5]*paste(" emissions in Baltimore ",
                                     "City by various source types", sep=""))) +
  geom_label(aes(fill = type), colour = "white", fontface = "bold")
dev.off()