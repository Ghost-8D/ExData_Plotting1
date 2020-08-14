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
png(filename = "plot4.png", width = 480, height = 480)
par(bg = NA) # For transparent background

# Prepare a 2x2 grid for the 4 plots
par(mfcol=c(2,2))

# Add top left plot
plot(target_data$Full_Date, target_data$Global_active_power, pch=NA, xlab = NA, 
     ylab="Global Active Power (kilowatts)")
lines(target_data$Full_Date, target_data$Global_active_power, 
      xlim=range(target_data$Full_Date), 
      ylim=range(target_data$Global_active_power), pch=16)

# Add bottom left plot
# Add the line for Sub_metering_1 
plot(target_data$Full_Date, target_data$Sub_metering_1, pch=NA, xlab=NA, 
     ylab="Energy sub metering")
lines(target_data$Full_Date, target_data$Sub_metering_1, 
      xlim=range(target_data$Full_Date), 
      ylim=range(target_data$Sub_metering_1), pch=16, col="black")
# Add the line for Sub_metering_2
points(target_data$Full_Date, target_data$Sub_metering_2, pch=NA)
lines(target_data$Full_Date, target_data$Sub_metering_2, 
      xlim=range(target_data$Full_Date), 
      ylim=range(target_data$Sub_metering_2), pch=16, col="red")
# Add the line for Sub_metering_3
points(target_data$Full_Date, target_data$Sub_metering_3, pch=NA)
lines(target_data$Full_Date, target_data$Sub_metering_3, 
      xlim=range(target_data$Full_Date), 
      ylim=range(target_data$Sub_metering_3), pch=16, col="blue")
# Add legend
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col=c("black", "red", "blue"), lty=c(1, 1, 1), cex=0.9, box.lty=0)

# Add top right plot
plot(target_data$Full_Date, target_data$Voltage, pch=NA, xlab="datetime", ylab="Voltage")
lines(target_data$Full_Date, target_data$Voltage, 
      xlim=range(target_data$Full_Date), 
      ylim=range(target_data$Voltage), pch=16, col="black")

# Add bottom right plot
plot(target_data$Full_Date, target_data$Global_reactive_power, pch=NA, xlab="datetime", 
     ylab="Global reactive power")
lines(target_data$Full_Date, target_data$Global_reactive_power, 
      xlim=range(target_data$Full_Date), 
      ylim=range(target_data$Global_reactive_power), pch=16, col="black")
dev.off()

# Cleanup
rm(target_data)
file.remove(file)
rm(file)
detach("package:data.table", unload=TRUE)
detach("package:tidyr", unload=TRUE)
detach("package:lubridate", unload=TRUE)