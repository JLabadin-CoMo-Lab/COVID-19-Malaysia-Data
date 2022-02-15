raw <- read.csv('https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/cases_state.csv',sep = ',',header = TRUE)
deathRaw <- read.csv('https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/deaths_state.csv',sep=',',header = TRUE)
pre <- read.csv('D:/MOZZHUB/COVID-19-Malaysia-Data/srwk_case.csv',sep=",",header = TRUE)
last <- tail(pre,n=1)
lastDate <- as.Date(last$Date)
sar <- raw[raw$state=="Sarawak"&raw$date>lastDate,]
deathSar <- deathRaw[deathRaw$state=="Sarawak"&deathRaw$date>lastDate,]
new <- sar$cases_new
rec <- sar$cases_recovered
death <- deathSar$deaths_new
newC <- c()
recC <- c()
deaC <- c()
day <- last$Day+c(1:length(new))
date <- lastDate+c(1:length(new))
for(i in 1:length(new)){
  if(i==1){
    newC[i] <- last$Positive[1]+new[i]
    recC[i] <- last$Rec[1]+rec[i]
    deaC[i] <- last$Death+death[i]
  }
  else{
    newC[i] <- newC[i-1]+new[i]
    recC[i] <- recC[i-1]+rec[i]
    deaC[i] <- deaC[i-1]+death[i]  
  }
}
case <- newC-recC-deaC

newRow <- data.frame(day,date,newC,recC,deaC,case)

write.table(newRow,file = 'D:/MOZZHUB/COVID-19-Malaysia-Data/srwk_case.csv',sep = ',', 
            append = T, 
            row.names=F, 
            col.names=F)
