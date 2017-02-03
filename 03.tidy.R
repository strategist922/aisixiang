library(readr)
D <- read_csv("aisixiang_2017-01-20.csv")
Av <- read_csv("Av.csv")
Availablity <- substr(Av[[1]], 1, 1)
table(Availablity)

D_com <- cbind(D, Availablity)

write.csv(D_com, "aisixiang_2017-01-20_com.csv", row.names = F)
