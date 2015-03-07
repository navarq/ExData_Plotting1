plot3 <- function(){
        
        # hold originally directory location
        old.dir <- getwd()
        
        # if the file does not exist then download it
        if(!file.exists("./exdata-data-household_power_consumption.zip")){
                download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                              destfile="exdata-data-household_power_consumption.zip")
                # print date downloaded
                print(date())
        }        
        
        # Verify that the file exists
        if(!file.exists("./data/household_power_consumption.txt")){
                # extract the file to the data folder
                unzip("exdata-data-household_power_consumption.zip", exdir = "data", overwrite=TRUE)
        } 
        
        ## Move to the extracted directory
        setwd("./data")
        
        # load package sqldf into workspace
        require(sqldf)
        
        # Use SQL and string matching to get data by date
        households<- read.csv.sql(
                "household_power_consumption.txt", 
                sep=";", 
                sql = "select * from file where Date in ('1/2/2007','2/2/2007')"
                
        )
        # Close all connections
        closeAllConnections()
        
        # load package lubridate into workspace
        require(lubridate)
        
        householdDates <- dmy_hms(paste(households$Date, households$Time))
        
        plot(householdDates,
             households$Sub_metering_1, 
             type="n",
             ylab="Energy sub metering", xlab="")
        lines(householdDates, households$Sub_metering_1)
        lines(householdDates, households$Sub_metering_2, col="red")
        lines(householdDates, households$Sub_metering_3, col="blue")
        legend("topright", lwd=1,
               col=c("black",
                     "red",
                     "blue"),
               legend=c(
                       "Sub_metering_1", 
                       "Sub_metering_2",
                       "Sub_metering_3"
               ))
        # Save in original directory, defaults to 480x480 width height in pixels
        dev.copy(png,file="../plot3.png")
        dev.off()
        setwd(old.dir)
}