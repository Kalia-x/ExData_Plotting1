
#################

require(lubridate)

# download the data set, if it doesn't already exist in the working directory
# (has already been downloaded previously)
if(!file.exists("exdata_data_household_power_consumption.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                  "exdata_data_household_power_consumption.zip")
}
if(!dir.exists("exdata_data_household_power_consumption")) {
    unzip("exdata_data_household_power_consumption.zip", 
          exdir="exdata_data_household_power_consumption")
}

# read the data set into R, unless it has been read into R already
if(!exists("bigTable")) {
    classes <- c("character", "character", "numeric", "numeric", "numeric", 
                 "numeric", "numeric", "numeric", "numeric")
    bigTable <- read.table("exdata_data_household_power_consumption/household_power_consumption.txt", 
                           sep=";", header=TRUE, na.strings="?", colClasses=classes)
}

# create the data frame of date subsets, unless it already exists
if(!exists("dateSubset")) {
    
    #subset data from only dates within the range 2007-02-01 and 2007-02-02
    dateSubset <- bigTable[bigTable$Date == "1/2/2007" | bigTable$Date == "2/2/2007", ]
    
    # convert the date/time columns into date/time class objects
    dateSubset$Date <- dmy(dateSubset$Date)
    timeVector <- strptime(dateSubset$Time, format="%H:%M:%S", tz="UTC")
    timeVector[dateSubset$Date=="2007-02-01"] <- update(timeVector[dateSubset$Date=="2007-02-01"], 
                                                        years=2007, months=2, days=1)
    timeVector[dateSubset$Date=="2007-02-02"] <- update(timeVector[dateSubset$Date=="2007-02-02"], 
                                                        years=2007, months=2, days=2)         
    dateSubset$Time <- timeVector
    row.names(dateSubset) <- NULL
}

#################

#create the histogram plot 1
png(file="plot1.png", width=480, height=480, bg="transparent")

hist(dateSubset$Global_active_power,
              col="red",
              xlab="Global Active Power (kilowatts)",
              main="Global Active Power")
dev.off()
