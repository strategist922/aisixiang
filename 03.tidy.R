library(readr)
library(magrittr)

# 2017-05-24 --------------------------------------------------------------

D20170524 <- read_csv("all_aisixiang_2017-05-24.csv")
Av20170524 <- read_csv("Av20170524.csv")
Av <- strsplit(Av20170524[[1]], '_')

Availablity <- vector(length = length(Av))
ID <- vector(length = length(Av))
i <- 1
for(i in 1:length(Av)){
  Availablity[i] <- Av[[i]][1]
  ID[i] <- Av[[i]][2]
  i <- i + 1
  i
}
ID <- cbind(ID, Availablity)
ID %<>% as.data.frame()
ID$ID %<>% as.character() %<>% as.numeric()
ID$Availablity %<>% as.character() %<>% as.numeric()

aisixiang_2017_05_24 <- merge(D20170524, ID, by = "ID")

write.csv(aisixiang_2017_05_24, 'aisixiang_2017_05_24_full.csv', row.names = F)