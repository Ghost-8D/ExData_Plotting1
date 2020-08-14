# Load libraries
library(data.table)
library(tidyr)
library(lubridate)

# Download the dataset from the url if it does not exist
file <- "household_power_consumption.txt"
if (!file.exists(file)){
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    dest_file <- "electric_power_data.zip"
    download.file(url, destfile = dest_file, method = "curl")
    unzip(dest_file)
    file.remove(dest_file)
    rm(url)
    rm(dest_file)
}

# Read data from file
data <- fread(file, header=TRUE, sep=";", na.strings = "?")
data <- as_tibble(data)

# Convert string date to Date object
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

# Get only data between dates 2007-02-01 and 2007-02-02
target_data <- subset(data, Date <= "2007-02-02" & Date >= "2007-02-01")

# Remove initial dataset to free memory
rm(data)

# Convert column to numeric so that it can be used in plots
target_data$Global_active_power <- as.numeric(target_data$Global_active_power)
target_data$Full_Date <- strptime(paste(target_data$Date, target_data$Time), 
                                  format = "%Y-%m-%d %H:%M:%S")


# Create a PNG device to save the plot with shape 480x480 pixels
png(filename = "plot2.png", width = 480, height = 480)
par(bg = NA)
# Add the data points without displaying them
plot(target_data$Full_Date, target_data$Global_active_power, pch=NA, xlab = NA, 
     ylab="Global Active Power (kilowatts)")
# Draw the line between the points
lines(target_data$Full_Date, target_data$Global_active_power, 
      xlim=range(target_data$Full_Date), 
      ylim=range(target_data$Global_active_power), pch=16)
dev.off()

# Cleanup
rm(target_data)
file.remove(file)
rm(file)