plot2 <- function(){
        
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
        
        # Use sqldf into workspace
        require(sqldf)
        
        # Use SQL and string matching to get data by date
        households<- read.csv.sql(
                "household_power_consumption.txt", 
                sep=";", 
                sql = "select * from file where Date in ('1/2/2007','2/2/2007')"
                
        )
        # Close all connections
        closeAllConnections()
        plot(dmy_hms(paste(households$Date, households$Time)),
             households$Global_active_power, 
             type="l",
             ylab="Global Active Power (kilowatts)", xlab="")
        # Save in original directory, defaults to 480x480 width height in pixels
        dev.copy(png,file="../plot2.png")
        dev.off()
        setwd(old.dir)
}