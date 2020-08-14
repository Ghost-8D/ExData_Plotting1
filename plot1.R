# Load libraries
library(data.table)
library(tidyr)

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

# Create a PNG device to save the plot with shape 480x480 pixels
png(filename = "plot1.png", width = 480, height = 480, bg = )
par(bg = NA)
hist(target_data$Global_active_power, xlab = "Global Active Power (kilowatts)", col = "red", main = "Global Active Power")
dev.off()

# Cleanup
rm(target_data)
file.remove(file)
rm(file)
detach("package:data.table", unload=TRUE)
detach("package:tidyr", unload=TRUE)