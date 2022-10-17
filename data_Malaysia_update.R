raw <- read.csv('https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/cases_malaysia.csv',sep = ',',header = TRUE)
deathRaw <- read.csv('https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/deaths_malaysia.csv',sep=',',header = TRUE)
pre <- read.csv('./Mal_case.csv',sep=",",header = TRUE)
last <- tail(pre,n=1)
lastDate <- as.Date(last$Date, format="%m/%d/%Y")
if(is.na(lastDate)){
  lastDate <- as.Date(last$Date)
}
lastDateRaw <- tail(raw,n=1)$date
if(lastDate==lastDateRaw){
  print("All Updated")
} else{
  mal <- raw[raw$date>lastDate,]
  deathMal <- deathRaw[deathRaw$date>lastDate,]
  new <- mal$cases_new
  rec <- mal$cases_recovered
  death <- deathMal$deaths_new
  newC <- c()
  recC <- c()
  deaC <- c()
  day <- last$Day+c(1:length(new))
  date <- lastDate+c(1:length(new))
  for(i in 1:length(new)){
    #date[i] <- as.Date(lastDate,origin="1900-01-01")+i
    if(i==1){
      newC[i] <- last$Reported[1]+new[i]
      recC[i] <- last$Recovered[1]+rec[i]
      deaC[i] <- last$Death+death[i]
    }
    else{
      newC[i] <- newC[i-1]+new[i]
      recC[i] <- recC[i-1]+rec[i]
      deaC[i] <- deaC[i-1]+death[i]  
    }
  }
  case <- newC-recC-deaC
  
  newRow <- data.frame(day,newC,recC,deaC,case,date)
  write.table(newRow,file = './Mal_case.csv',sep = ',',
              append = T, 
              row.names=F, 
              col.names=F)
}
