plot1 <- function(){
        
        # hold originally directory location
        old.dir <- getwd()
        
        # if the file does not exist then download it
        if(!file.exists("./exdata-data-household_power_consumption.zip")){
                download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                              destfile="exdata-data-household_power_consumption.zip")
        }        
        
        # extract the file to the data folder
        unzip("exdata-data-household_power_consumption.zip", exdir = "data", overwrite=TRUE)
        
        ## Move to the extracted directory
        setwd("./data")
        
        # Verify that the file exists
        if(!file.exists("household_power_consumption.txt")){
                message("No extracted file found!")
        }
        
        # Use sqldf into workspace
        require(sqldf)
        
        households<- as.date.frame(read.csv.sql(
                "household_power_consumption.txt", 
                sep=";", 
                sql = "select (substr(Date,7) || '-' || substr(Date,4,2) || '-' || substr(Date,1,2)) as adate, Time as time, Global_Active_Power as globalactivepower, global_reactive_power as globalreactivepower, voltage, global_intensity as globalintensity, Sub_metering_1 as submetering1, Sub_metering_2 as submetering2, Sub_metering_3 as submetering3 from file")
        closeAllConnections()
        households$datetime <-paste(households$date, households$time)
        households$datetime<-as.POSIXct(households$datetime, format="%Y-%m-%d %h:%m%s")) 
        
        
        households<- read.csv.sql(
                "household_power_consumption.txt", 
                sep=";", 
                sql = "select * from file where Date ='02/02/2007'"
                
        )
        closeAllConnections()
        
        #col.names=c("date","time"
        #         ,"globalactivepower"
        #         ,"globalreactivepower"
        #         ,"voltage"
        #         ,"globalinsensity"
        #         ,"submetering1"
        #         ,"submetering2"
        #         ,"submetering3")
        #data <- read.csv("./data/household_power_consumption.txt", header=TRUE, sep=";")[66638:69517,]
        require(data.table)
        houses <- fread("household_power_consumption.txt", 
                        skip=66637, 
                        header=FALSE,
                        sep = ";", stringsAsFactors=FALSE, nrows=2880)
        setnames(houses,c("date","time","globalactivepower","globalreactivepower","voltage" ,"globalinsensity","submetering1","submetering2" ,"submetering3"))
        hist(houses$globalactivepower, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power")
        dev.copy(png,file="plot1.png")
        dev.off()
}