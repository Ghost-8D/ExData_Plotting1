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
data <- fread(file, header=TRUE, sep=";", na.strings = "?", 
              colClasses = c("character", "character", "numeric", "numeric", 
                             "numeric", "numeric", "numeric", "numeric", "numeric"))
data <- as_tibble(data)

# Get only data between dates 2007-02-01 and 2007-02-02
target_data <- subset(data, Date == "2/2/2007" | Date == "1/2/2007")

# Remove initial dataset to free memory
rm(data)

# Add column with datetime
target_data$Full_Date <- strptime(paste(target_data$Date, target_data$Time), 
                                  format = "%d/%m/%Y %H:%M:%S")

# Create a PNG device to save the plot with shape 480x480 pixels
png(filename = "plot4.png", width = 480, height = 480)
par(bg = NA) # For transparent background

# Prepare a 2x2 grid for the 4 plots
par(mfcol=c(2,2))

# Add top left plot
plot(target_data$Full_Date, target_data$Global_active_power, xlab = NA, type="l",
     ylab="Global Active Power")

# Add bottom left plot
# Add the line for Sub_metering_1 
plot(target_data$Full_Date, target_data$Sub_metering_1, xlab=NA, type="l",
     ylab="Energy sub metering")
# Add the line for Sub_metering_2
points(target_data$Full_Date, target_data$Sub_metering_2, type="l", col="red")
# Add the line for Sub_metering_3
points(target_data$Full_Date, target_data$Sub_metering_3, type="l", col="blue")
# Add legend
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black", "red", "blue"), lty=c(1, 1, 1), cex=0.9, box.lty=0)

# Add top right plot
plot(target_data$Full_Date, target_data$Voltage, type="l", xlab="datetime", ylab="Voltage")

# Add bottom right plot
plot(target_data$Full_Date, target_data$Global_reactive_power, type="l", xlab="datetime", 
     ylab="Global reactive power")

dev.off()

# Cleanup
rm(target_data)
file.remove(file)
rm(file)
detach("package:data.table", unload=TRUE)
detach("package:tidyr", unload=TRUE)
detach("package:lubridate", unload=TRUE)