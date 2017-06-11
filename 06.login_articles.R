library(jiebaR)
library(readr)

setwd('20170524_0611/')

Files <- list.files()
Files2 <- Files[6:length(Files)]

W <- worker("keywords", topn = 10)

L <- list()
j <- 1
for(i in Files2){
  D0 <- read_table(i)
  D1 <- gsub("\\s+", '', D0$X1)
  D1 <- na.omit(D1)
  D1 <- paste(D1,collapse="") 
  D1 <- gsub("\\s+", '', D1)
  L[[j]] <- keywords(D1, W)
  j <- j + 1
}

L2 <- as.data.frame(L)
names(L2) <- 1:ncol(L2)
write.csv(L2, "keys.csv", row.names = F)

Keys <- read_csv("keys.csv")
Keys <- unclass(Keys)
Keys <- unlist(Keys)
table(Keys) %>% sort(., decreasing = T) %>% View()

