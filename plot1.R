# plot1.R
# Coursera Exploratory Data Analysis Project 1
# Nicholas Jackson 2016
# https://github.com/njacko/ExData_Plotting1
#



library(dplyr);
library(lubridate);

# Data reading and set up section - The same for all plot scripts
# ----------------------------------------------------------------
#

# having already determined the number of rows, set nrows to be slightly more
# than that to make reading in data faster.

# numrows = 2075265;    # this would read the entire file
numrows = 2880;         # read the 2880 rows that match our required dates.

# skip this many rows when reading file
numskip = 66637;

# data is semicolon separated
classes <- c("character", "character", "numeric", "numeric", "numeric", 
             "numeric", "numeric", "numeric", "numeric");


# This section of code is so that only the required rows are read, in order to 
# speed up the process. 

# read the first row to get the header
hdr <- read.table("household_power_consumption.txt", header = TRUE, sep = ";",
                  nrows = 1);

# read 'numrows' of the data, minus the header, and skip 'numskip' rows
d <- read.table("household_power_consumption.txt", header = FALSE, 
                       sep = ";", colClasses = classes, nrows = numrows, 
                       skip = numskip, na.strings = c("?"));

# wrap the data in a dplyr tbl
d <- tbl_df(d);

# Set the names based on the header we read.
names(d) <- names(hdr);

# convert to lubridate date format
d$Date <- dmy(d$Date);

# select only data for the required dates. This is not really needed as we have 
# hardcoded the dates, but I leave it here in case one wants to read the entire
# file.
d <- d[(d$Date == "2007-02-01" | d$Date == "2007-02-02"),];

# convert to POSIXct time format
d$Time <- as.POSIXct(paste(d$Date, d$Time), format="%Y-%m-%d %H:%M:%S");

# Specific data manipulation for this plot
# ------------------------------------------------
#

# add a column for the day of the week - 'weekday'
d <- mutate(d, weekday = wday(Date, label = TRUE));

# Plotting section
# -------------------------------------------------------------
#

# set up labelling
xname = "Global Active Power (kilowatts)";
yname = "Frequency";
maintitle = "Global Active Power";

# open png file
png(file = "plot1.png", width = 480, height = 480, units = "px");

# create plot
hist(d$Global_active_power, col = "red", xlab = xname, ylab = yname,
        main = maintitle);

# close device
dev.off()

# -------------------------------------------------------------
# end of file