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

## Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle
## sources in Los Angeles County, California (fips=="06037????????????????????"). Which city has seen greater 
## changes over time in motor vehicle emissions?
baltcitymary.emissions<-summarise(group_by(filter(NEI, fips == "24510"& type =='ON-ROAD'), year), Emissions=sum(Emissions))
losangelscal.emissions<-summarise(group_by(filter(NEI, fips == "06037"& type == 'ON-ROAD'), year), Emissions=sum(Emissions))

baltcitymary.emissions$County <- "Baltimore City, MD"
losangelscal.emissions$County <- "Los Angeles County, CA"
both.emissions <- rbind(baltcitymary.emissions, losangelscal.emissions)

png("plot6.png")
ggplot(both.emissions, aes(x=factor(year), y=Emissions, fill=County,label = round(Emissions,2))) +
  geom_bar(stat="identity") + 
  facet_grid(County~., scales="free") +
  ylab(expression("total PM"[2.5]*" emissions in tons")) + 
  xlab("year") +
  ggtitle(expression("Motor vehicle emission variation in Baltimore and Los Angeles in tons"))+
  geom_label(aes(fill = County),colour = "white", fontface = "bold")
dev.off()