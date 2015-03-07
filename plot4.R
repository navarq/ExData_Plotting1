plot4 <- function(){
        
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
        
        # Create a new datetime column
        households$datetime <- dmy_hms(paste(households$Date, households$Time))
        
        png(file="../plot4.png",width=480, height=480)
        
        par(mfrow=c(2,2))
        # Plot 2
        require(lubridate)
        plot(Global_active_power ~ datetime, households,
             type="l",
             ylab="Global Active Power", xlab="")
        # Plot New Voltage vs Date
        plot(Voltage ~ datetime, households,type="l")
        # Plot 3
        plot(Sub_metering_1 ~ datetime, households,
             type="n",
             ylab="Energy sub metering", xlab="")
        lines(Sub_metering_1 ~ datetime, households)
        lines(Sub_metering_2 ~ datetime, households, col="red")
        lines(Sub_metering_3 ~ datetime, households, col="blue")
        # bty = n to remove border around legend
        legend("topright", lwd=1, bty="n",
               col=c("black",
                     "red",
                     "blue"),
               legend=c(
                       "Sub_metering_1", 
                       "Sub_metering_2",
                       "Sub_metering_3"
               ))
        
        # Plot 4
        plot(Global_reactive_power ~ datetime, households,  type="l")
        dev.off()
        setwd(old.dir)
}